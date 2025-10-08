# 🥭 Mangoman

> A lightweight Linux-centric learning project inspired by [appleboy/ssh-action](https://github.com/appleboy/ssh-action).  
> Mangoman allows users to easily log in to a remote server via SSH using a private key — all managed through a simple Python + Bash setup.

---

## ✨ Overview

Mangoman is a small hobby project designed to replicate one of the core capabilities of Appleboy’s GitHub Action — executing commands on a remote server through SSH.  
It’s built primarily for learning and experimentation with Python and Bash scripting.

With Mangoman, users can:
- Automate SSH logins using private SSH keys.
- Define a fixed set of commands to execute remotely.
- Customize command sets easily after setup.
- Understand the integration between Bash scripting and Python automation.

---

## 🧩 Tech Stack

- **Python 3** — for handling SSH connections.
- **Bash** — for setup automation and shell integration.
- **Linux environment** — designed and tested primarily for Linux systems.

---

## 🚀 Getting Started

### 📋 Prerequisites
- A **Linux** machine.
- **Python 3** installed and accessible from the terminal.
- SSH access to a remote server.
- A generated **private SSH key** on the server.

---

### ⚙️ Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/your-username/mangoMan.git
   cd mangoMan
   ```

2. **Run Setup**

   ```bash
   bash setup.sh
   ```

   This script will:
   - Install required dependencies.
   - Create necessary directories and configuration files.
   - Prompt you for SSH credentials.
   - Allow you to specify initial commands for execution.

3. **Reload Your Shell**

   After setup, reload your shell environment so that the `mango` command is recognized:

   ```bash
   source ~/.bashrc
   ```
   *(or `source ~/.zshrc`, depending on your shell)*

4. **Start Mangoman**

   Once configured, simply run:

   ```bash
   mango
   ```

   This will initiate the SSH session using your configured credentials and commands.

---

## 🧰 Configuration

### 🪶 Add or Modify Commands

During setup, you’ll be prompted to enter a fixed set of commands that Mangoman will execute on the remote server.

If you want to add or modify commands later, you have two options:

1. **Run the custom command script:**

   ```bash
   ./bashes/custom_commands.sh
   ```

2. **Manually edit the commands file:**

   ```bash
   nano ./secrets_and_variables/commands.txt
   ```

   > Each command must be written **one per line**.

---

## 🔑 SSH Key Setup

Mangoman relies on your SSH private key for authentication.  
If you haven’t set up SSH keys yet:

1. Generate a new key pair **on your server**:

   ```bash
   ssh-keygen -t rsa -b 4096
   ```
2. Copy and store the **private key** securely.
3. Provide it to Mangoman during setup when prompted.

---

## 📚 User’s Manual Summary

1. Clone this repository.  
2. Run `bash setup.sh`.  
3. Reload your shell (`source ~/.bashrc`).  
4. Type `mango` to start your SSH session.  
5. Modify commands as needed via `custom_commands.sh` or directly in the text file.  

---

## ⚠️ Disclaimer

This project is for **learning and educational purposes only**.  
Use it responsibly and **never share your private SSH keys**.  
Mangoman is not meant for production use or handling sensitive environments.

---

## 🧪 Purpose

This project was created as a **personal exploration** to better understand:
- SSH automation with Python.
- Script-based environment setup using Bash.
- The foundational concept behind remote command execution in GitHub Actions.

---

## 🧑‍💻 Author

**Rinchhen Thing**  
📦 GitHub: [@RinchhenThing](https://github.com/RinchhenThing)

---

## 📄 License

This project is released under the **MIT License**.  
See the [LICENSE](./LICENSE) file for more details.

---

## 🌟 Acknowledgments

- Inspired by [appleboy/ssh-action](https://github.com/appleboy/ssh-action)  
- Built as part of a personal learning journey in **Python scripting** and **automation**
