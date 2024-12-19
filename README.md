# PortWatcher
Monitors port reachability with notifications via Telegram and Gotify

This script monitors the reachability of a specific port on a given IP address. If the port becomes unreachable, it sends notifications about the port's status via Telegram and Gotify, avoiding repeated alerts until the port is reachable again. Upon recovery, a notification is sent, and monitoring continues.

# Port Monitoring Script

This script monitors the reachability of a specific port on a server and sends notifications via Telegram and Gotify when the port is unreachable or back online.

---

## Prerequisites

Before starting, ensure you have:

1. **Bash Installed**
   - Linux/macOS systems already include Bash.
   - For Windows, install [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) or use [Git Bash](https://git-scm.com/downloads).

2. **Telegram Setup**
   - Create a Telegram bot and obtain its **API token** by following [this guide](https://core.telegram.org/bots).
   - Get your Telegram chat ID using the [Telegram bot API](https://api.telegram.org/bot<your_bot_token>/getUpdates).

3. **Gotify Setup**
   - Set up a Gotify server ([instructions](https://gotify.net/docs/install)).
   - Obtain a valid **Gotify app token**.

4. **Dependencies**
   - Ensure the `nc` (Netcat) and `curl` commands are installed:
     ```bash
     sudo apt install netcat curl   # For Debian/Ubuntu
     sudo yum install nc curl       # For CentOS/RHEL
     ```

---

## Configuration

1. **Clone or Download the Script**
   - Clone this repository or download the `port_monitor.sh` file.

2. **Edit the Script**
   Open `port_monitor.sh` in a text editor and replace the placeholder values with your own:

   - **IP/Hostname and Port to Monitor:**
     ```bash
     ipToCheck="your-server-address.com"   # Replace with the server address or IP you want to monitor
     portToCheck=22                     # Replace with the port number you want to check
     ```

   - **Telegram Credentials:**
     ```bash
     telegramToken="YOUR_TELEGRAM_BOT_TOKEN"  # Replace with your Telegram bot API token
     telegramChatId="YOUR_TELEGRAM_CHAT_ID"  # Replace with the Telegram chat ID
     ```

   - **Gotify Credentials:**
     ```bash
     gotifyServer="http://your-gotify-server.com"  # Replace with your Gotify server URL
     token="YOUR_GOTIFY_APP_TOKEN"                 # Replace with your Gotify app token
     ```

   - **Time Settings (optional):**
     ```bash
     timeoutSeconds=5   # Time in seconds to wait for a connection
     intervalMinutes=8  # Time in minutes between checks
     ```

3. **Save the File**

---

## Usage

1. **Make the Script Executable**
   Run the following command to give the script execution permissions:
   ```bash
   chmod +x port_monitor.sh
   ```

2. **Run the Script Execute the script using:**
   ```bash
   ./port_monitor.sh
   ```
   You can use `screen` too
   ```bash
   screen -dmS PortWatcher ./port_monitor.sh
   ```

4. **Press `Ctrl+C` to stop the script. It will terminate cleanly and stop monitoring.**


---

## Notifications

- **Down Alert:** When the monitored port becomes unreachable, notifications will be sent via Telegram and Gotify.
- **Recovery Alert:** When the port is back online, a recovery notification will be sent.

---

## Troubleshooting

1. **Error: Command Not Found**
   - Ensure `nc` (Netcat) and `curl` are installed:
     ```bash
     sudo apt install netcat curl   # For Debian/Ubuntu
     sudo yum install nc curl       # For CentOS/RHEL
     ```

2. **Telegram Not Sending Messages**
   - Double-check the `telegramToken` and `telegramChatId` values.
   - Test your bot by visiting this URL in your browser:
     ```
     https://api.telegram.org/bot<YOUR_TELEGRAM_BOT_TOKEN>/sendMessage?chat_id=<YOUR_CHAT_ID>&text=TestMessage
     ```

3. **Gotify Not Sending Messages**
   - Ensure your Gotify server is running and accessible.
   - Verify your app token and server URL.

4. **Script Not Running**
   - Ensure the script has executable permissions:
     ```bash
     chmod +x port_monitor.sh
     ```
   - Make sure you're running the script in a Bash-compatible terminal.

