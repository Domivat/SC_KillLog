# -------------------------------
# 1. Relativer Pfad zu Konfigurationsdateien und Logdatei
# -------------------------------

# Konfigurationsdateien und Output-Datei relativ zum Skript-Verzeichnis
$logConfigFile   = Join-Path -Path $PSScriptRoot -ChildPath "lastSelectedLog.txt"
$playerConfigFile = Join-Path -Path $PSScriptRoot -ChildPath "lastPlayerName.txt"
$OutFile         = Join-Path -Path $PSScriptRoot -ChildPath "killLog.txt"

# Standardpfad für die Logdatei: Verzeichnis, in dem das Script liegt + \StarCitizen\HOTFIX\Game.log
$defaultLogFile = Join-Path -Path $PSScriptRoot -ChildPath "StarCitizen\HOTFIX\Game.log"

# -------------------------------
# 2. Logdatei-Auswahl mit Speicherung der zuletzt verwendeten Logdatei
# -------------------------------

# Prüfe, ob die Konfigurationsdatei für den Logdateipfad existiert
if (Test-Path $logConfigFile) {
    try {
        $lastSelectedLogFile = Get-Content $logConfigFile -ErrorAction Stop
    }
    catch {
        $lastSelectedLogFile = $defaultLogFile
    }
} else {
    $lastSelectedLogFile = $defaultLogFile
}

Add-Type -AssemblyName System.Windows.Forms

$openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$openFileDialog.Filter = "Log-Dateien (*.log;*.txt)|*.log;*.txt|Alle Dateien (*.*)|*.*"
$openFileDialog.Title = "Bitte Log-Datei auswählen"
$openFileDialog.FileName = $lastSelectedLogFile

$result = $openFileDialog.ShowDialog()
if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $LogFile = $openFileDialog.FileName
    $LogFile | Out-File -FilePath $logConfigFile -Encoding UTF8
} else {
    Write-Host "Keine Logdatei ausgewählt. Skript wird beendet."
    exit
}

# -------------------------------
# 3. Spielername-Eingabe mit Speicherung des zuletzt verwendeten Namens
# -------------------------------

$defaultPlayerName = "Unknown"
if (Test-Path $playerConfigFile) {
    try {
        $lastPlayerName = Get-Content $playerConfigFile -ErrorAction Stop
    }
    catch {
        $lastPlayerName = $defaultPlayerName
    }
} else {
    $lastPlayerName = $defaultPlayerName
}

Add-Type -AssemblyName Microsoft.VisualBasic

$PlayerName = [Microsoft.VisualBasic.Interaction]::InputBox("Bitte geben Sie den Spielernamen ein:", "Spielername", $lastPlayerName)
if ([string]::IsNullOrWhiteSpace($PlayerName)) {
    Write-Host "Kein Spielername eingegeben. Skript wird beendet."
    exit
}
# Speichere den eingegebenen Spielernamen
$PlayerName | Out-File -FilePath $playerConfigFile -Encoding UTF8

# -------------------------------
# 4. Log-Überwachung und -Auswertung
# -------------------------------

# Regex-Muster zum Extrahieren der relevanten Informationen:
# Gruppe 1: Datum/Zeit (zwischen <> am Zeilenanfang)
# Gruppe 2: Name des Opfers (nach "CActor::Kill:" in einfachen Anführungszeichen)
# Gruppe 3: Opfer-ID (in eckigen Klammern direkt hinter dem Opfernamen)
# Gruppe 4: Name des Killers (nach "killed by" in einfachen Anführungszeichen)
# Gruppe 5: Killer-ID (in eckigen Klammern direkt hinter dem Killernamen)
$pattern = "^<([^>]+)>.*CActor::Kill:\s+'([^']+)'\s+\[([^\]]+)\].*killed by\s+'([^']+)'\s+\[([^\]]+)\]"

Write-Host "Starte statische Durchsuchung des Logfiles..."

# 4.1 Statische Durchsuchung des gesamten Logfiles
Get-Content -Path $LogFile | ForEach-Object {
    $line = $_
    if ($line -match $pattern) {
        # Filtere Zeilen, bei denen weder das Opfer noch der Killer dem eingegebenen Spieler entspricht
        if (($matches[2] -ne $PlayerName) -and ($matches[4] -ne $PlayerName)) {
            return
        }
        $date     = $matches[1]
        $victim   = $matches[2]
        $victimId = $matches[3]
        $killer   = $matches[4]
        $killerId = $matches[5]
        
        $output = "Am $date wurde $victim [$victimId] von $killer [$killerId] getötet."
        $output | Add-Content -Path $OutFile
        Write-Host "Eintrag (statisch) hinzugefügt: $output"
    }
}

Write-Host "Statische Durchsuchung abgeschlossen. Starte Live-Überwachung..."

# 4.2 Live-Überwachung neuer Zeilen in der Logdatei
Get-Content -Path $LogFile -Wait -Tail 0 | ForEach-Object {
    $line = $_
    if ($line -match $pattern) {
        if (($matches[2] -ne $PlayerName) -and ($matches[4] -ne $PlayerName)) {
            return
        }
        $date     = $matches[1]
        $victim   = $matches[2]
        $victimId = $matches[3]
        $killer   = $matches[4]
        $killerId = $matches[5]
        
        $output = "Am $date wurde $victim [$victimId] von $killer [$killerId] getötet."
        $output | Add-Content -Path $OutFile
        Write-Host "Eintrag (live) hinzugefügt: $output"
    }
}
