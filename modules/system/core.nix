{ pkgs, host, username, ... }:

{
  networking.hostName = host;
  networking.networkmanager.enable = true;

  time.timeZone = "America/Indiana/Indianapolis";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "zh_CN.UTF-8/UTF-8" ];

  # Btrfs 优化
  fileSystems."/".options = [ "compress=zstd" "noatime" ];
  fileSystems."/home".options = [ "compress=zstd" "noatime" ];
  fileSystems."/nix".options = [ "compress=zstd" "noatime" ];

  # Nix 设置
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # 用户定义
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "gamemode" ];
    shell = pkgs.fish;
  };
  programs.fish.enable = true;

  # 系统必备包
  environment.systemPackages = with pkgs; [
    git vim wget curl btop helix
  ];
}
