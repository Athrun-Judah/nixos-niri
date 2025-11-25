{ config, pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false; # 桌面高性能模式
    powerManagement.finegrained = false;
    open = false; # 使用闭源专有驱动
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.production;

    prime = {
      # 启用 offload 模式
      offload.enable = true;

      # 让 Intel iGPU 处理显示
      # 如果您有 AMD iGPU，请改为 "amdgpu"
      intelBusId = "PCI:0:2:0";

      # 让 NVIDIA dGPU 处理渲染
      nvidiaBusId = "PCI:2:0:0";
    };
  };
}
