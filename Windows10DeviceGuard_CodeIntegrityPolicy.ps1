# PLEASE NOTE: This script is only for demo purposes. 
# 
# This Windows PowerShell script helps you to configure and enable Device Guard in Windows 10. 
# 
# Sebastian Klenk's Blog:
# http://blogs.technet.com/b/sebastianklenk
# 

# 1. Initialize Variables
$CIPolicyPath=$env:userprofile+"\Desktop\"
$InitialCIPolicy=$CIPolicyPath+"InitialScan.xml"
$CIPolicyBin=$CIPolicyPath+"DeviceGuardPolicy.bin"

# 2. Create a new Code Integrity Policy through checking installed applications
New-CIPolicy -Level PcaCertificate -Fallback Hash -FilePath $InitialCIPolicy –UserPEs 3> CIPolicyLog.txt

# 3. Convert Code Integrity Policy to binary format
ConvertFrom-CIPolicy $InitialCIPolicy $CIPolicyBin

# 4. Reboot PC

# 5. Initialize Variables
$CIPolicyPath=$env:userprofile+"\Desktop\" 
$InitialCIPolicy=$CIPolicyPath+"InitialScan.xml" 
$EnforcedCIPolicy=$CIPolicyPath+"EnforcedPolicy.xml"
$CIPolicyBin=$CIPolicyPath+"EnforcedDeviceGuardPolicy.bin"

# 6. Copy initial file to create a backup 
cp $InitialCIPolicy $EnforcedCIPolicy

# 7. Remove Audit Mode rule option 
Set-RuleOption -Option 3 -FilePath $EnforcedCIPolicy -Delete 

# 8. Convert new Code Integrity Policy to binary format 
ConvertFrom-CIPolicy $EnforcedCIPolicy $CIPolicyBin 

# 9. Copy EnforcedDeviceGuardPolicy.bin from Desktop to System32 folder "C:\Windows\System32\CodeIntegrity\EnforcedDeviceGuardPolicy.bin"

# 10. gpedit -> "Computer Configuration\Administrative Templates\System\Device Guard"
#
#     a) Enable "Deploy Code Integrity Policy"            ->   "C:\Users\Desktop\EnforcedDeviceGuardPolicy.bin"
#
#     b) Enable "Turn On Virtualization Based Security"   ->   Checkbox "Enable Virtualization Based Protection of Code Integrity"
#                                                              Listbox  "Secure Boot and DMA Protection"

# 11. Force Group Policy update
gpupdate /force

# 12. Reboot PC

# 13. Now test Device Guard on your system, e.g. by running an application downloaded from the internet that has not been on the system before creating your Code Integrity Policy.
