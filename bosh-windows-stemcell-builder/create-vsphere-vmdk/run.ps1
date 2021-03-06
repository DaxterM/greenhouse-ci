﻿$ErrorActionPreference = "Stop";
trap { $host.SetShouldExit(1) }

$VMDK="C:\Users\Administrator\Desktop\output.vmdk"
$env:PATH="$env:PATH;C:\Program Files (x86)\StarWind Software\StarWind V2V Image Converter"

$vmx_text = @"
.encoding = "UTF-8"
checkpoint.vmState = ""
cleanShutdown = "TRUE"
config.version = "8"
displayName = "BOSH-Windows-Stemcell"
ehci.pciSlotNumber = "34"
ehci.present = "TRUE"
ehci:0.deviceType = "video"
ehci:0.parent = "-1"
ehci:0.port = "0"
ethernet0.addressType = "generated"
ethernet0.connectionType = "nat"
ethernet0.generatedAddress = "00:0c:29:44:c9:a1"
ethernet0.generatedAddressOffset = "0"
ethernet0.linkStatePropagation.enable = "TRUE"
ethernet0.pciSlotNumber = "192"
ethernet0.present = "TRUE"
ethernet0.virtualDev = "e1000e"
ethernet0.wakeOnPcktRcv = "FALSE"
floppy0.present = "FALSE"
guestOS = "windows8srv-64"
hgfs.linkRootShare = "true"
hgfs.mapRootShare = "true"
hpet0.present = "TRUE"
ide0:0.autodetect = "TRUE"
ide0:0.deviceType = "cdrom-raw"
ide0:0.fileName = "auto detect"
ide0:0.present = "TRUE"
ide0:0.startConnected = "FALSE"
isolation.tools.hgfs.disable = "false"
mem.hotadd = "TRUE"
memsize = "2048"
mks.enable3d = "TRUE"
monitor.phys_bits_used = "40"
numvcpus = "2"
pciBridge0.pciSlotNumber = "17"
pciBridge0.present = "TRUE"
pciBridge4.functions = "8"
pciBridge4.pciSlotNumber = "21"
pciBridge4.present = "TRUE"
pciBridge4.virtualDev = "pcieRootPort"
pciBridge5.functions = "8"
pciBridge5.pciSlotNumber = "22"
pciBridge5.present = "TRUE"
pciBridge5.virtualDev = "pcieRootPort"
pciBridge6.functions = "8"
pciBridge6.pciSlotNumber = "23"
pciBridge6.present = "TRUE"
pciBridge6.virtualDev = "pcieRootPort"
pciBridge7.functions = "8"
pciBridge7.pciSlotNumber = "24"
pciBridge7.present = "TRUE"
pciBridge7.virtualDev = "pcieRootPort"
powerType.powerOff = "soft"
powerType.powerOn = "soft"
powerType.reset = "soft"
powerType.suspend = "soft"
sata0.present = "FALSE"
sata0:1.present = "FALSE"
scsi0.pciSlotNumber = "160"
scsi0.present = "TRUE"
scsi0.virtualDev = "lsisas1068"
scsi0:0.fileName = "${VMDK}"
scsi0:0.present = "TRUE"
scsi0:0.redo = ""
serial0.fileType = "thinprint"
serial0.present = "TRUE"
softPowerOff = "TRUE"
tools.remindInstall = "FALSE"
tools.syncTime = "TRUE"
tools.upgrade.policy = "upgradeAtPowerCycle"
toolsInstallManager.lastInstallError = "0"
toolsInstallManager.updateCounter = "1"
vcpu.hotadd = "TRUE"
virtualHW.productCompatibility = "hosted"
virtualHW.version = "9"
vmci0.pciSlotNumber = "35"
vmci0.present = "TRUE"
"@

$vmx_text | Out-File $env:VMX_PATH

Remove-Item $VMDK -ErrorAction SilentlyContinue
StarV2Vc.exe if="${env:VHD}" of="$VMDK" ot=vmdk_s

cd "stemcell-builder"
bundle install
if ($LASTEXITCODE -ne 0) {
  Write-Error "Could not bundle install"
  Exit 1
}
rake package:agent
if ($LASTEXITCODE -ne 0) {
  Write-Error "Could not package agent"
  Exit 1
}
rake package:psmodules
if ($LASTEXITCODE -ne 0) {
  Write-Error "Could not package psmodules"
  Exit 1
}

ruby ../ci/bosh-windows-stemcell-builder/create-vsphere-vmdk/run.rb

