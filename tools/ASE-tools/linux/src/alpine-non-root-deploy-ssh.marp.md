---
marp: true
title: Running Docker Deployment as a Non-Root User (Alpine)
theme: default
paginate: true
---

# 👤 Create a User for Deployment on Alpine

Stop using root for everything!  
Learn how to:

- Create a secure user
- Give Git and Docker access
- Deploy a Flask app safely
- Use SSH keys for secure login

---

## 🧑‍💻 Step 1: Create a New User

```bash
adduser -D deploy
```

- `-D` creates the user with default settings
- Home directory: `/home/deploy`

---

## 🔐 Step 2: Set a Password

```bash
passwd deploy
```

- You'll be prompted to enter and confirm the password
- Now you can `su - deploy` or login via password-based SSH

---

## 🔑 Step 3: Set Up SSH Key Access (Optional)

1. From your **local machine**, generate a key (if not already):

```bash
ssh-keygen
```

2. Copy the public key to the server:

```bash
ssh-copy-id deploy@your-server-ip
```

> If `ssh-copy-id` is not available, you can manually copy the contents of `~/.ssh/id_rsa.pub` to the server.

---

## 🛠️ Step 4: Manual SSH Key Setup (Optional, only if Step 3 is not working)

On the server:

```bash
su - deploy
mkdir -p ~/.ssh
nano ~/.ssh/authorized_keys
```

- Paste your public key (from your local `~/.ssh/id_rsa.pub`)
- Save and exit
- Set permissions:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

---

## 🛠️ Step 5: Add User to Docker Group

```bash
addgroup deploy docker
```

✅ Now the `deploy` user can run `docker` without `sudo`

---

## 🌐 Step 6: Clone the Repository

```bash
su - deploy
git clone https://github.com/make2grow/my-flask-app.git my-flask-app
cd my-flask-app
```

---

## ⚙️ Step 7: Create the Deploy Script

```bash
nano ~/deploy.sh
```

Paste:

```bash
#!/bin/sh
cd ~/my-flask-app/flask
git pull origin main
docker build -t flask-app .
docker stop flask-running
docker rm flask-running
docker run -d --name flask-running -p 80:5000 flask-app
```

Make it executable:

```bash
chmod +x ~/deploy.sh
```

---

## ✅ Summary

| Step | Description |
|------|-------------|
| `adduser -D deploy` | Create user |
| `passwd deploy` | Set password |
| `ssh-copy-id` | Add SSH public key |
| `addgroup deploy docker` | Enable Docker access |
| `git clone` | Pull your app |
| `~/deploy.sh` | Pull + build + restart |

---

# 🚀 Secure & Ready for Auto Deployment!
