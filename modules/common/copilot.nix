# Cross-platform GitHub Copilot CLI configuration.
{ ... }:
{
  home.file.".copilot/copilot-instructions.md" = {
    source = ./ai-guidelines.md;
    force = true;
  };

  home.file.".copilot/mcp-config.json" = {
    text = builtins.toJSON {
      mcpServers.apify = {
        type = "http";
        url = "https://mcp.apify.com";
        tools = [ "*" ];
      };
    };
    force = true;
  };
}
