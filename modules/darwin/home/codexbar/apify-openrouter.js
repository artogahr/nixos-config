// CodexBar provider: OpenRouter spend billed through Apify (apify/openrouter and the
// artogahr/openrouter-relay Actor). Totals are the billed run costs. The split by model is an
// estimate: each run's billed cost is divided between its requests by OpenRouter list prices,
// because apify/openrouter records tokens per request but not cost.
const API = "https://api.apify.com/v2";
const MODELS_URL = "https://openrouter.ai/api/v1/models";
const UPSTREAM_ACTOR = "apify~openrouter";
const RELAY_ACTOR = "artogahr~openrouter-relay";
const UNFINISHED = ["READY", "RUNNING"];
// The host aborts a fetch after 20 seconds, and ctx.date stays at the refresh start, so the
// budget counts dataset requests (about 0.25 s each) instead of time.
const DATASET_REQUESTS_PER_REFRESH = 25;
const PRICE_TTL_MS = 24 * 60 * 60 * 1000;
const FALLBACK_TOKEN_PRICE = 1e-7;
const DEFAULT_MIN_SHOWN_USD = 1;
const BRANDS = { deepseek: "DeepSeek", gpt: "GPT", glm: "GLM", mimo: "MiMo" };

// "deepseek/deepseek-v4.1-flash-1017" -> "DeepSeek V4.1 Flash"
function displayName(model) {
  if (model.startsWith("(")) return model;
  return model
    .split("/")
    .pop()
    .replace(/-(\d{4}|\d{8})$/, "")
    .split("-")
    .map((word) => BRANDS[word] || word.charAt(0).toUpperCase() + word.slice(1))
    .join(" ");
}

defineProvider({
  id: "apify-openrouter",
  name: "OpenRouter on Apify",
  icon: { monogram: "AO", tint: "#246DFF" },
  // No manifest `auth`: the host would send it to every endpoint, including openrouter.ai.
  endpoints: ["https://api.apify.com", "https://openrouter.ai"],
  capabilities: ["persistent-storage"],
  settings: [
    {
      key: "APIFY_TOKEN",
      title: "Apify API token",
      subtitle: "From Apify Console > Settings > API & Integrations.",
      type: "secure",
    },
    {
      key: "MIN_SHOWN_USD",
      title: "Hide models under (USD)",
      subtitle: "Default 1. Set 0 to show every model.",
      type: "plain",
    },
  ],

  async fetchUsage(ctx) {
    const token = ctx.settings.getSecret("APIFY_TOKEN");
    if (!token) throw ctx.fail.missingCredential("Set the Apify API token in the plugin settings");
    const auth = { headers: { Authorization: `Bearer ${token}` } };
    const minSetting = (ctx.settings.get("MIN_SHOWN_USD") || "").trim();
    const minShown = minSetting && Number.isFinite(Number(minSetting)) ? Number(minSetting) : DEFAULT_MIN_SHOWN_USD;

    async function apify(path) {
      try {
        return (await ctx.http.getJSON(`${API}${path}`, { ...auth, retryPolicy: "transientIdempotent" })).json;
      } catch (error) {
        if (error && (error.status === 401 || error.status === 403)) {
          throw ctx.fail.authenticationExpired("Apify rejected the API token");
        }
        throw error;
      }
    }

    const limits = (await apify("/users/me/limits")).data;
    const cycleStart = limits.monthlyUsageCycle.startAt;
    const cycleEnd = limits.monthlyUsageCycle.endAt;

    function load(key) {
      const text = ctx.storage.get(key);
      if (!text) return null;
      try {
        return JSON.parse(text);
      } catch {
        return null;
      }
    }
    function fresh() {
      return { cycleStart, upstream: { cursor: null, billed: 0, runs: 0 }, relay: { cursor: null, billed: 0, runs: 0 }, models: {}, days: {} };
    }
    let state = load("state");
    if (!state || state.cycleStart !== cycleStart) state = fresh();

    const after = (run, cursor) =>
      !cursor || run.startedAt > cursor.startedAt || (run.startedAt === cursor.startedAt && run.id > cursor.id);

    // Runs of an Actor that started in this cycle after the cursor, oldest first.
    async function newRuns(actor, cursor) {
      const runs = [];
      for (let offset = 0; ; offset += 100) {
        const page = (await apify(`/acts/${actor}/runs?desc=1&limit=100&offset=${offset}`)).data.items;
        let done = page.length < 100;
        for (const run of page) {
          if (run.startedAt < cycleStart || !after(run, cursor)) {
            done = true;
            break;
          }
          runs.push(run);
        }
        if (done) break;
      }
      return runs.reverse();
    }

    let prices = load("prices");
    let fullMap = null;
    let pricesTried = false;
    async function priceFor(models) {
      const now = ctx.date.nowMillis();
      const missing = models.filter((m) => !(prices && m in prices.map));
      if (prices && now - prices.fetchedAt < PRICE_TTL_MS && missing.length === 0) return;
      if (fullMap) {
        for (const m of missing) prices.map[m] = fullMap[m] || null;
        ctx.storage.set("prices", JSON.stringify(prices));
        return;
      }
      // Fetch the list at most once per refresh, even if it fails.
      if (pricesTried) return;
      pricesTried = true;
      let list;
      try {
        list = (await ctx.http.getJSON(MODELS_URL)).json.data;
      } catch (error) {
        ctx.log("Model prices unavailable", String(error));
        return;
      }
      const map = {};
      for (const model of list) {
        const p = model.pricing || {};
        const entry = [Number(p.prompt) || 0, Number(p.completion) || 0, Number(p.input_cache_read ?? p.prompt) || 0];
        map[model.id] = entry;
        if (model.canonical_slug) map[model.canonical_slug] = entry;
      }
      fullMap = map;
      const keep = new Set([...Object.keys(state.models), ...models, ...(prices ? Object.keys(prices.map) : [])]);
      prices = { fetchedAt: now, map: {} };
      // null marks a model without a list price, so it does not trigger a new download.
      for (const m of keep) prices.map[m] = map[m] || null;
      ctx.storage.set("prices", JSON.stringify(prices));
    }

    let datasetRequests = 0;
    async function rows(datasetId) {
      const all = [];
      const fields = "timestamp,model,promptTokens,completionTokens,promptTokensDetails";
      for (let offset = 0; ; offset += 2000) {
        datasetRequests += 1;
        const page = await apify(`/datasets/${datasetId}/items?clean=1&fields=${fields}&offset=${offset}&limit=2000`);
        all.push(...page);
        if (page.length < 2000) return all;
      }
    }

    // Splits one run's billed cost between its requests by list-price weight.
    function allocate(run, items, models, days) {
      const billed = run.usageTotalUsd || 0;
      if (items.length === 0) {
        add(models, "(no requests recorded)", billed, 0, 0, 0);
        addDay(days, run.startedAt, billed);
        return;
      }
      const weights = items.map((row) => {
        const input = Number(row.promptTokens) || 0;
        const output = Number(row.completionTokens) || 0;
        const cached = Number(row.promptTokensDetails?.cached_tokens) || 0;
        const price = prices?.map[row.model];
        if (!price) return (input + output) * FALLBACK_TOKEN_PRICE;
        return (input - cached) * price[0] + cached * price[2] + output * price[1];
      });
      const total = weights.reduce((a, b) => a + b, 0);
      items.forEach((row, i) => {
        const share = total > 0 ? weights[i] / total : 1 / items.length;
        const usd = billed * share;
        add(models, row.model || "(unknown model)", usd, 1, Number(row.promptTokens) || 0, Number(row.completionTokens) || 0);
        addDay(days, row.timestamp || run.startedAt, usd);
      });
    }
    function add(models, model, usd, requests, input, output) {
      const m = models[model] || (models[model] = [0, 0, 0, 0]);
      m[0] += usd;
      m[1] += requests;
      m[2] += input;
      m[3] += output;
    }
    function addDay(days, timestamp, usd) {
      const day = timestamp.slice(0, 10);
      days[day] = (days[day] || 0) + usd;
    }

    // Finished runs before the first unfinished one are saved; later runs are counted live.
    const upstreamRuns = await newRuns(UPSTREAM_ACTOR, state.upstream.cursor);
    const live = { models: {}, days: {}, billed: 0 };
    let saving = true;
    let skipped = 0;
    let skippedUsd = 0;
    for (const run of upstreamRuns) {
      if (datasetRequests >= DATASET_REQUESTS_PER_REFRESH) {
        skipped += 1;
        skippedUsd += run.usageTotalUsd || 0;
        continue;
      }
      const items = await rows(run.defaultDatasetId);
      await priceFor([...new Set(items.map((row) => row.model).filter(Boolean))]);
      if (saving && !UNFINISHED.includes(run.status)) {
        allocate(run, items, state.models, state.days);
        state.upstream.billed += run.usageTotalUsd || 0;
        state.upstream.runs += 1;
        state.upstream.cursor = { startedAt: run.startedAt, id: run.id };
        ctx.storage.set("state", JSON.stringify(state));
      } else {
        saving = false;
        allocate(run, items, live.models, live.days);
        live.billed += run.usageTotalUsd || 0;
      }
    }

    let relayLive = 0;
    let relaySaving = true;
    for (const run of await newRuns(RELAY_ACTOR, state.relay.cursor)) {
      if (relaySaving && !UNFINISHED.includes(run.status)) {
        state.relay.billed += run.usageTotalUsd || 0;
        state.relay.runs += 1;
        state.relay.cursor = { startedAt: run.startedAt, id: run.id };
      } else {
        relaySaving = false;
        relayLive += run.usageTotalUsd || 0;
      }
    }
    ctx.storage.set("state", JSON.stringify(state));

    const models = JSON.parse(JSON.stringify(state.models));
    for (const [model, m] of Object.entries(live.models)) add(models, model, m[0], m[1], m[2], m[3]);
    const days = { ...state.days };
    for (const [day, usd] of Object.entries(live.days)) days[day] = (days[day] || 0) + usd;

    const upstreamBilled = state.upstream.billed + live.billed + skippedUsd;
    const relayBilled = state.relay.billed + relayLive;
    const spent = upstreamBilled + relayBilled;
    const usd = (value) => ctx.format.usd(value);
    const tokens = (value) =>
      value >= 1e6 ? `${(value / 1e6).toFixed(1)}M` : value >= 1e3 ? `${(value / 1e3).toFixed(0)}k` : String(value);
    const requests = Object.values(models).reduce((sum, m) => sum + m[1], 0);

    const summary = [
      { label: "Models (apify/openrouter)", value: usd(upstreamBilled) },
      ...(relayBilled >= minShown ? [{ label: "Relay compute", value: usd(relayBilled) }] : []),
      { label: "Requests", value: ctx.format.number(requests) },
      {
        label: "Apify account",
        value: `${usd(limits.current.monthlyUsageUsd)} of ${usd(limits.limits.maxMonthlyUsageUsd)}`,
        secondaryValue: "All Apify usage this cycle",
        progress: Math.min(1, limits.current.monthlyUsageUsd / limits.limits.maxMonthlyUsageUsd),
      },
    ];
    if (skipped > 0) {
      summary.push({
        label: "Still loading",
        value: `${skipped} runs`,
        secondaryValue: `${usd(skippedUsd)} not split by model yet`,
      });
    }

    const named = {};
    for (const [model, m] of Object.entries(models)) add(named, displayName(model), m[0], m[1], m[2], m[3]);
    // A section holds at most 24 rows; the last one sums the hidden models.
    const sorted = Object.entries(named).sort((a, b) => b[1][0] - a[1][0]);
    const shown = sorted.filter(([, m]) => m[0] >= minShown).slice(0, 23);
    const hidden = sorted.slice(shown.length);
    const modelRows = shown.map(([model, m]) => ({
      label: model.length > 60 ? `${model.slice(0, 59)}…` : model,
      value: usd(m[0]),
      secondaryValue: `${m[1]} req, ${tokens(m[2])} in, ${tokens(m[3])} out`,
    }));
    if (hidden.length) {
      modelRows.push({
        label: `${hidden.length} more models`,
        value: usd(hidden.reduce((sum, [, m]) => sum + m[0], 0)),
        secondaryValue: "Change the threshold in the plugin settings",
      });
    }
    const dayPoints = Object.keys(days)
      .sort()
      .map((day) => ({ label: day, value: Math.round(days[day] * 100) / 100 }));
    // CodexBar shows no label when hovering a plugin chart bar, so the days are also listed as rows.
    const dayRows = dayPoints
      .filter((point) => point.value >= minShown)
      .reverse()
      .slice(0, 10)
      .map((point) => ({ label: ctx.format.monthDay(ctx.date.iso(`${point.label}T00:00:00Z`)), value: usd(point.value) }));

    const details = [{ title: "This billing cycle", rows: summary }];
    if (modelRows.length) details.push({ title: "By model (estimated split)", rows: modelRows });
    if (dayRows.length) {
      details.push({
        title: "Daily spend",
        rows: dayRows,
        chart: { kind: "bars", title: "Daily spend", unit: "USD", points: dayPoints.slice(-120) },
      });
    }

    return {
      cost: { used: spent, limit: 0, currency: "USD", period: "This billing cycle" },
      primary: {
        usedPercent: ctx.pct(limits.current.monthlyUsageUsd, limits.limits.maxMonthlyUsageUsd),
        resetsAt: cycleEnd,
      },
      identity: { loginMethod: "Apify API token" },
      dataConfidence: "exact",
      details,
    };
  },
});
