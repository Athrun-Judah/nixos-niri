{ pkgs, lib, ... }:

{
  # 确保系统创建了 /etc/brave/policies/managed 目录
  # 并将策略写入 JSON 文件
  environment.etc."brave/policies/managed/my-policies.json".text = builtins.toJSON {
    BraveAIChatEnabled = false;
    BraveRewardsDisabled = true;
    BraveVPNDisabled = true;
    BraveWalletDisabled = true;
    BraveTalkDisabled = true;
    PasswordManagerEnabled = false;

    # 你还可以添加其他常用的禁用项，例如检查默认浏览器
    DefaultBrowserSettingEnabled = false;
  };
}
