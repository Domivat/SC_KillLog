# SC_KillLog

## English Version

Just a small PowerShell script where you can select the Star Citizen log file and enter your player name. If a log file already exists, the script will check for any kills by or against you and add them to a kill log, which will be created in the same location where you placed the script on your local machine.

I created a support ticket with CIG to check if this might be an issue with the Terms of Service. I’ll update this once I get a response.

**Response:**  
Thank you for your inquiry. Third party applications are "use at your own risk". There are no officially endorsed or allowed programs at this time. While it is unlikely that you would be outright banned for a third party application it could potentially be problematic.

That doesn’t help all that much, so here’s my understanding of why this script *should not* be an issue:

All the information is already available in plain text on your PC, so this script is just filtering that existing data.

### What it does **not** do:
- Scrape the game or game files for information  
- Attempt to access the game’s API  
- Automate anything inside Star Citizen  
- Provide any unfair advantage  

### What it **does**:
- Filters a readable file called `Game.log` in the Star Citizen installation directory – you know, the one you check when the game crashes on startup or similar issues.

As far as I can tell, it doesn’t violate any rules – but I’m not entirely sure.

## Deutsche Version

Nur ein kleines PowerShell-Skript, bei dem man das Logfile von Star Citizen und den eigenen Spielernamen auswählen kann. Wenn bereits ein Logfile existiert, prüft das Skript, ob dort Kills von dir oder gegen dich enthalten sind, und fügt diese zu einem Kill-Log hinzu, das an dem Ort erstellt wird, an dem du das Skript lokal abgelegt hast.

Ich habe ein Support-Ticket bei CIG erstellt, um zu prüfen, ob das eventuell ein Problem in Bezug auf die Nutzungsbedingungen (ToS) darstellt. Ich werde ein Update geben, sobald ich eine Antwort erhalte.

**Antwort:**  
Vielen Dank für Ihre Anfrage. Anwendungen von Drittanbietern werden auf eigene Gefahr verwendet. Es gibt derzeit keine offiziell unterstützten oder erlaubten Programme. Auch wenn es unwahrscheinlich ist, dass Sie aufgrund einer Drittanbieter-Anwendung direkt gebannt werden, kann es potenziell problematisch sein.

Da das nicht wirklich weiterhilft, hier mein Verständnis, warum dieses Skript kein Problem darstellen sollte:

Alle Informationen befinden sich bereits als lesbarer Text auf deinem PC, das Skript filtert diese lediglich heraus.

### Was es **nicht** macht:
- Scraping von Spiel- oder Spieldateien zur Informationsgewinnung  
- Zugriff auf die Game-API, um Daten zu erhalten  
- Automatisierung irgendeiner Handlung in Star Citizen  
- Einen unfairen Vorteil verschaffen  

### Was es **macht**:
- Filtert eine lesbare Datei namens `Game.log` im StarCitizen-Installationsordner – du weißt schon, die Datei, in die man reinschaut, wenn das Spiel beim Start abstürzt usw.

Soweit ich das beurteilen kann, verstößt es nicht gegen die Regeln – aber ich bin mir nicht zu 100 % sicher.
