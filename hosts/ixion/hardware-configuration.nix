{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [
    "kvm-intel"
    "iwlwifi"
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = [ ];
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];

  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/2b415557-d7b0-4ee4-bd2c-145536cf403e";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };

  hardware.enableRedistributableFirmware = true;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
      intel-compute-runtime
      vpl-gpu-rt
    ];
  };

  services.thermald.enable = true;
  powerManagement.powertop.enable = true;

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
