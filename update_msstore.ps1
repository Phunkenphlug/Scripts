# Remember old value if store is blocked i.e. by gpo
$oldValue = (get-itemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windowsstore -Name requirePrivateStoreOnly).requirePrivateStoreOnly

# enable store if prohibited
if ($oldValue -in (0,1)) { set-itemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windowsstore -Name RequirePrivateStoreOnly -Value 0 -Type DWord }

# kill storeprocess 
stop-process "winstore.app"

# reset Store and download again
wsreset.exe -i

# open store on downloadpage
start ms-windows-store://downloadsandupdates

# trigger updates of the store apps
Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod

# restore old value for the policy
if ($oldValue-in (0,1)) { set-itemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windowsstore -Name RequirePrivateStoreOnly -Value $oldValue -Type DWord }
