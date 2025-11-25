{ pkgs, ... }:

{
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      fcitx5-gtk
      fcitx5-configtool
    ];
  };

  # 链接雾凇拼音数据
  xdg.dataFile."fcitx5/rime" = {
    source = "${pkgs.rime-ice}/share/rime-ice";
    recursive = true;
  };

  # 小鹤双拼配置
  xdg.dataFile."fcitx5/rime/default.custom.yaml".text = ''
    patch:
      "menu/page_size": 7
      schema_list:
        - schema: double_pinyin_flypy
        - schema: rime_ice
  '';
}
