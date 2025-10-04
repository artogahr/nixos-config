{ pkgs, ... }:

let
  # Add/remove languages here - servers and formatters are auto-installed
  lspServers = {
    nix = { server = pkgs.nixd; formatter = pkgs.nixfmt; };
    lua = { server = pkgs.lua-language-server; formatter = pkgs.stylua; };
    rust = { server = pkgs.rust-analyzer; formatter = pkgs.rustfmt; };
    typst = { server = pkgs.tinymist; formatter = pkgs.typstyle; };
    # Add more languages here as needed:
    # python = { server = pkgs.pyright; formatter = pkgs.black; };
    # go = { server = pkgs.gopls; formatter = pkgs.gofumpt; };
    # c_sharp = { server = pkgs.omnisharp-roslyn; formatter = null; };
    # javascript = { server = pkgs.typescript-language-server; formatter = pkgs.prettierd; };
  };
  
  allServers = builtins.attrValues (builtins.mapAttrs (_: v: v.server) lspServers);
  allFormatters = builtins.filter (x: x != null) (builtins.attrValues (builtins.mapAttrs (_: v: v.formatter) lspServers));
in
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    defaultEditor = true;
    
    extraPackages = allServers ++ allFormatters ++ (with pkgs; [
      ripgrep
      fd
    ]);
    
    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip
      nvim-autopairs
      gitsigns-nvim
      comment-nvim
      nvim-surround
      undotree
      trouble-nvim
      telescope-nvim
      plenary-nvim
      which-key-nvim
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
    ];
    
    extraLuaConfig = ''
      -- Basic settings
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.wrap = true
      vim.opt.linebreak = true
      vim.opt.clipboard = "unnamedplus"
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.opt.smartindent = true
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.hlsearch = false
      vim.opt.termguicolors = true
      vim.opt.signcolumn = "yes"
      vim.opt.scrolloff = 8
      vim.opt.updatetime = 250
      vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
      
      -- Persistent undo
      vim.opt.undofile = true
      vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"
      
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "
      
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })
      
      local signs = { Error = "✘", Warn = "▲", Hint = "⚑", Info = "»" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
      
      -- Catppuccin theme
      require("catppuccin").setup({ flavour = "mocha", transparent_background = true })
      vim.cmd.colorscheme("catppuccin")
      
      -- LSP setup
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      
      local lsp_servers = { "nixd", "lua_ls", "rust_analyzer", "tinymist" }
      
      for _, server in ipairs(lsp_servers) do
        if vim.fn.executable(server == "lua_ls" and "lua-language-server" or server:gsub("_", "-")) == 1 then
          vim.lsp.enable(server)
        end
      end
      
      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
          if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
            vim.lsp.buf.format({ async = false })
          end
        end,
      })
      
      -- Plugins
      require("nvim-autopairs").setup({ check_ts = true })
      require("gitsigns").setup({})
      require("Comment").setup({})
      require("nvim-surround").setup({})
      require("trouble").setup({})
      
      -- Diagnostics keybindings
      vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
      vim.keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics" })
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
      vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, { desc = "Hover documentation" })
      
      local luasnip = require("luasnip")
      local cmp = require("cmp")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
        },
      })
      
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      
      require("telescope").setup({})
      
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["ai"] = "@conditional.outer",
              ["ii"] = "@conditional.inner",
              ["al"] = "@loop.outer",
              ["il"] = "@loop.inner",
            },
          },
        },
      })
      
      local wk = require("which-key")
      wk.setup({})
      wk.add({
        { "<leader>f", group = "Find" },
        { "<leader>c", group = "Code" },
        { "<leader>r", group = "Refactor" },
        { "<leader>x", group = "Diagnostics" },
        { "<leader>u", desc = "Undo tree" },
        { "[d", desc = "Previous diagnostic" },
        { "]d", desc = "Next diagnostic" },
      })
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = desc })
          end
          
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gr", vim.lsp.buf.references, "Go to references")
          map("gi", vim.lsp.buf.implementation, "Go to implementation")
          map("K", vim.lsp.buf.hover, "Hover documentation")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        end,
      })

      local telescope = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", telescope.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", telescope.buffers, { desc = "Find buffers" })
      vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
      vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
      vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Undo tree" })
    '';
  };
}
