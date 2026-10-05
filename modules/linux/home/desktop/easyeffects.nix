{ ... }:

{
  services.easyeffects = {
    enable = true;
  };

  # Output presets are deployed from ./desktop-extras.nix (xdg.configFile."easyeffects/output").
  # Automatic preset per output device:
  # EasyEffects remembers "last used preset" per output in ~/.config/easyeffects/db/easyeffectsrc
  # ([StreamOutputs] usedPresets=...). After deploying these presets, open EasyEffects, switch to
  # each output device (speakers, headphones, etc.), select the preset you want; that mapping is
  # saved and will auto-load when you switch outputs. We don't manage easyeffectsrc from Nix so
  # window size and your device→preset choices stay under your control.
}
