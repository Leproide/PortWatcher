#!/bin/bash

portToCheck=22  # Change this variable to the port number to monitor
timeoutSeconds=5  # Maximum wait time in seconds for the connection
intervalMinutes=8  # Interval in minutes between checks
ipToCheck="your-server-address.com"
notifiedDown=0  # Flag to track if the down notification has already been sent

function send_telegram {
    message="$1"
    telegramToken="YOUR_TELEGRAM_BOT_TOKEN"
    telegramChatId="YOUR_TELEGRAM_CHAT_ID"

    response=$(curl -s --max-time 10 -X POST "https://api.telegram.org/bot${telegramToken}/sendMessage" -d "chat_id=${telegramChatId}&text=${message}")
    if [ $? -ne 0 ]; then
        echo "$(date '+%d/%m/%Y %H:%M:%S') - Error sending Telegram message."
    fi
}

function send_gotify {
    message="$1"
    token="YOUR_GOTIFY_APP_TOKEN"
    gotifyServer="http://your-gotify-server.com"
    gotifyPort="8090"

    requestBody=$(cat <<EOF
{
    "title": "Monitoring $ipToCheck",
    "message": "$message"
}
EOF
)

    uri="${gotifyServer}:${gotifyPort}/message"

    response=$(curl -s --max-time 10 -X POST -H "X-Gotify-Key: ${token}" -H "Content-Type: application/json" -d "${requestBody}" "$uri")
    if [ $? -ne 0 ]; then
        echo "$(date '+%d/%m/%Y %H:%M:%S') - Error sending Gotify message."
    else
        echo "Gotify message sent successfully. Response: $response"
    fi
}

function check_port_and_notify {
    nc -z -w "$timeoutSeconds" "$ipToCheck" "$portToCheck"
    if [ $? -eq 0 ]; then
        # Port is reachable
        dt=$(date '+%d/%m/%Y %H:%M:%S');
        echo "$dt - Port $portToCheck on $ipToCheck is reachable."
        
        if [ $notifiedDown -eq 1 ]; then
            # If previously notified as down, send recovery message
            message="Port $portToCheck on $ipToCheck is now reachable!"
            send_telegram "$message"
            send_gotify "$message"
            notifiedDown=0  # Reset the flag
        fi
    else
        # Port is not reachable
        dt=$(date '+%d/%m/%Y %H:%M:%S');
        echo "$dt - Port $portToCheck on $ipToCheck is not reachable."
        
        if [ $notifiedDown -eq 0 ]; then
            # Send notifications only once
            message="Port $portToCheck on $ipToCheck is not reachable!"
            send_telegram "$message"
            send_gotify "$message"
            notifiedDown=1  # Set the flag
        fi
    fi
}

function cleanup {
    echo "Script interrupted, exiting cleanly."
    exit 0
}

trap cleanup SIGINT SIGTERM

# Main loop to check the port at the specified interval
while true; do
    echo "Checking port $portToCheck on $ipToCheck..."
    check_port_and_notify

    # Wait for the specified interval before running the next check
    sleep "$((intervalMinutes * 60))"
done
