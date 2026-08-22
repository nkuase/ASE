---
marp: true
title: Password-less SSH Login
theme: default
paginate: true
---

# 🔐 Password-less SSH Login
A guide for secure and convenient login using SSH key pairs

---

## 1. 🎯 Goal
Enable SSH login **without typing a password**, using:

- SSH key authentication (public/private key)
- Optional SSH config file for convenience

---

## 2. 🧰 Step 1: Generate SSH Key Pair

Run on **your local machine**:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/my_key -C "your_email@example.com"
```
- You can change file name instead of my_key.
- Make paraphrase only when you need more security. 
Press Enter to accept default file: `~/.ssh/id_rsa`

<!-- 
Old method
  ssh-keygen -t rsa -b 4096 -C "your_email@example.com" 
-->
--- 

Creates:

~/.ssh/my_key (private key)
~/.ssh/my_key.pub (public key)



---

## 3. 📤 Step 2: Copy Public Key to Server

Option 1: Use `ssh-copy-id` (recommended)

server_ip is the IP address of your server. 

```bash
ssh-copy-id -i ~/.ssh/my_key username@server_ip
```

Option 2: Manually copy (not recommended):

```bash
cat ~/.ssh/id_rsa.pub | ssh username@server_ip 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys'
```

---

## 4. 🔧 Step 3: Server-side SSH Config

Edit `/etc/ssh/sshd_config` on the **remote server**:

```
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
PasswordAuthentication no   # optional (disables password login)
```

Then restart SSH service:

```bash
sudo systemctl restart sshd
```

---

## 5. 🪪 Step 4: Optional – SSH Config (Local)

Add entry in `~/.ssh/config` for convenience:

```
Host myserver
    HostName server_ip
    User username
    IdentityFile ~/.ssh/id_rsa
```

Now you can simply:

```bash
ssh myserver
```

---

## ✅ Done!

You can now log in **without a password**:

- No need to enter `username@host` every time
- No password prompt if private key is loaded

---

# 🙌 Questions?

Let me know if you want multi-server setup, or GitHub/CI integration!
