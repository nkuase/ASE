---
marp: true
theme: default
class: lead
paginate: true
---

# 🐧 Simple Alpine VPS Setup Script


---

## 🧠 What is This Script?

- It's a **setup script** written in `sh` (POSIX shell)
- Used on a **VPS (Virtual Private Server)** running **Alpine Linux**
- Automates:
  - User creation
  - Security settings
  - Docker installation
  - Development tools setup

---

## 🌐 What is Alpine Linux?

- A lightweight, security-oriented Linux distribution
- Great for VPS and Docker
- Has small package manager: `apk`

---

## 🔐 Password Setup
```sh
PASSWORD=YOUR_PASSWORD
```
- You set this before running
- Used for the `deploy` user
- Must be **at least 8 characters**

---

## 🧑 Create User and Set Password

```sh
adduser -D deploy
```
- Creates a user named `deploy`

```sh
echo "deploy:$PASSWORD" | chpasswd
```
- Sets the password for that user

---

## 🔓 Sudo (Admin Rights)
```sh
apk add sudo
addgroup deploy wheel
```
- `deploy` user is added to `wheel` group
- `sudo` lets user run admin commands

---

## 🔥 UFW Firewall Setup
```sh
apk add ufw
ufw default deny incoming
ufw allow 22 80 443 9000 3000 8080
ufw enable
```
- Blocks all incoming by default
- Allows specific ports: SSH, HTTP, HTTPS, etc.

---

## 🔒 Secure SSH
```sh
sed -i 's/#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
```
- Prevents root from logging in via SSH
- SSH server is restarted after changes

---

## 🐳 Docker Installation
```sh
apk add docker docker-cli docker-compose
rc-update add docker boot
service docker start
```
- Installs and starts Docker
- Adds `deploy` to `docker` group

---

## 💻 Install Development Tools
```sh
apk add git curl wget vim build-base zip unzip ...
```
- Basic developer tools
- Useful for editing, compiling, downloading

---

## 🛡️ Fail2Ban for Brute Force Protection
```sh
apk add fail2ban
```
- Monitors logins and blocks attackers
- Configured to read `/var/log/auth.log` or `/var/log/messages`

---

## 📊 Monitoring Scripts
- `/home/deploy/disk-check.sh`
  - Alerts if disk is almost full
- `/home/deploy/system-info.sh`
  - Shows system info and Docker status

---

## ⚙️ Environment Config File
`/home/deploy/.env`
```env
DEPLOY_USER=deploy
ALLOWED_PORTS=22 80 443 ...
DOCKER_INSTALLED=true
```
- Contains key setup info

---

## ✅ After Running the Script

- Login as `deploy` user with password
- Run: `sudo docker run hello-world`
- Use monitoring scripts
- Check logs: `/var/log/deploy-setup/setup.log`

---

## 🧾 Summary

This script helps you:
- Quickly set up a secure Alpine VPS
- Install Docker & dev tools
- Create a new deploy user
- Harden SSH & firewall settings

---

## 🧪 Try It Yourself!

1. Launch Alpine VPS (e.g. on Vultr)
2. Set your password:
```sh
export PASSWORD="YourStrongPassword"
```
3. Run the script:
```sh
sh setup.sh
```

---

## ✨ Questions?

Let’s experiment, break things, and learn together! 🚀
