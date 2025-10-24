# speedtest-gas
Gathering speed test results

## Set up speedtest CLI
Download the executable binary and place it on the client

https://www.speedtest.net/apps/cli

## Set up scripts
Modify parameters in speedtest_uploader.sh

> GAS_ENDPOINT="https://script.google.com/macros/s/YOUR_GAS_URL_HERE/exec?site=YOUR_SITE_NAME_HERE"

> SPEEDTEST_CMD="/opt/homebrew/bin/speedtest"

For Windows, using PowerShell script speedtest_uploader.ps1

> $SpeedtestCliPath = "C:\Users\user\Projects\speedtest\speedtest.exe"

> $GasEndpointUrl = "https://script.google.com/macros/s/AKfycbzHEe5Eu9XpiLqPKVsaKhhjEci9oLaxD8c-q-JQhJKZogiW-VeVXf0QhfkpkHUJsP_qqw/exec?site=FCTVE(Guest)"

> $LogFilePath = "C:\Users\$env:USERNAME\Projects\speedtest\speedtest_log.txt"

parameter **site** for GasEndpointUrl is for identify the speedtest client. It will shown on the spreadsheet and the graph.

<img width="589" height="115" alt="image" src="https://github.com/user-attachments/assets/936f232b-0ce4-4476-b3ba-b91d62cd430a" />

<img width="1030" height="489" alt="image" src="https://github.com/user-attachments/assets/f8c98dca-58c8-4cf9-8b62-de4a0a1f2ac5" />

### speedtest server

If you want to change the server, change **-s** parameter on this line

>     $SpeedtestJson = & $SpeedtestCliPath -s 944 -f json --accept-license --accept-gdpr 2>&1

If you want to ommit it to choose automatically, delete -s <server_id> option.

## Set up scheduler

For macOS and Ubuntu, using cron

> crontab -e

> */10 * * * * YOUR_SCRIPT_PATH

For Windows using Task Scheduler

Action:

Program/script

> powershell.exe

Add arguments (optional) 

> -ExecutionPolicy Bypass -File "C:\Path\To\Your\speedtest_uploader.ps1"

