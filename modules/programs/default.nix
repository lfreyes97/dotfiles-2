{ config, pkgs, libs, ... }:
{
  imports = [ ./irssi.nix ./kitty.nix ];
  home.packages = with pkgs; [ brave rofi nyxt ];
  home.file.".config/rofi".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/rofi";
}