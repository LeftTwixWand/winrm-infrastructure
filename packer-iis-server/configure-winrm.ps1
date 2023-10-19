# #Configure WinRM (optional)
# winrm quickconfig -q
# winrm set winrm/config/service '@{AllowUnencrypted="true"}'
# winrm set winrm/config/service/auth '@{Basic="true"}'
# winrm set winrm/config/service/auth '@{CredSSP="true"}'
# winrm set winrm/config/client '@{TrustedHosts="*"}'
# New-NetFirewallRule -DisplayName "Enable WinRM 5986" -Direction Inbound -LocalPort 5986 -Protocol TCP -Action Allow
# New-NetFirewallRule -DisplayName "Enable WinRM 5985" -Direction Inbound -LocalPort 5985 -Protocol TCP -Action Allow
# Restart-Service winrm

winrm quickconfig;

$ip = "10.1.0.5";
$cert = New-SelfSignedCertificate -DnsName $ip -CertStoreLocation Cert:\LocalMachine\My;
winrm create winrm/config/Listener?Address=*+Transport=HTTPS '@{Hostname="'"$ip"'";CertificateThumbprint="'"$($cert.Thumbprint)"'"}';

winrm enumerate winrm/config/listener;

# Add a new firewall rule
$port=5986;
netsh advfirewall firewall add rule name="Windows Remote Management (HTTPS-In)" dir=in action=allow protocol=TCP localport=$port;





# $hostName="10.1.0.5"
# $winrmPort = "5986"

# # Get the credentials of the machine
# $cred = Get-Credential

# # Connect to the machine
# $soptions = New-PSSessionOption -SkipCACheck
# Enter-PSSession -ComputerName $hostName -Port $winrmPort -Credential $cred -SessionOption $soptions -UseSSL