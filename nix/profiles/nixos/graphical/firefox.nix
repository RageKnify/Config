# profiles/graphical/firefox.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Firefox configuration.

{ pkgs, config, lib, ... }: {
  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = with pkgs; [
      tridactyl-native
      gnome-browser-connector
    ];
    policies = {
      DisableFirefoxScreenshots = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      EncryptedMediaExtensions = {
        Enabled = true;
        Locked = true;
      };
      DisableTelemetry = true;
      PasswordManagerEnabled = false;

      UserMessaging = {
        # WhatsNew = false;
        ExtensionRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = false;
        MoreFromMozilla = false;
      };
      FirefoxHome = {
        # Search = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
        SponsoredTopSites = false;
      };
      ExtensionSettings = builtins.mapAttrs (name: value: {
        installation_mode = "normal_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/${value}/latest.xpi";
      }) {
        "uBlock0@raymondhill.net" = "ublock-origin";
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
        "@contain-facebook" = "facebook-container";
        "{48748554-4c01-49e8-94af-79662bf34d50}" = "privacy-pass";
      };
      OfferToSaveLogins = false;
      SearchSuggestEnabled = false;
      ShowHomeButton = false;
      Homepage = {
        URL = "about:blank";
        StartPage = "none";
      };
    };
  };
}
