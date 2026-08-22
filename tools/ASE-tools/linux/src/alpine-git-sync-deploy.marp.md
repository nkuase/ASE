---
marp: true
title: Auto-Pull Flask App on Alpine
theme: default
paginate: true
---

# 🤖 Auto-Pull Flask App on Alpine

Learn how to:

- Install Git on Alpine Linux
- Clone GitHub repo
- Set up deploy script to auto-update your Flask app

---

## 🧰 Step 1: Install Git on Alpine

Run the following commands:

```bash
apk update
apk add git
```

✅ This installs Git so you can pull from GitHub

---

## 🌐 Step 2: Clone Your GitHub Repository

Example: 

```bash
cd /home/deploy
git clone https://github.com/make2grow/my-flask-app.git 
```

- Clones the repo into `/home/user/my-flask-app`
- You can now build and run from this folder

---

## 🛠️ Step 3: Create the Deploy Script

Create the script:

```bash
nano /home/user/deploy.sh
```

Paste the following:

```bash
#!/bin/sh
cd /home/user/my-flask-app
git pull origin main
docker build -t flask-app .
docker stop flask-running
docker rm flask-running
docker run -d --name flask-running -p 80:5000 flask-app
```

Make it executable:

```bash
chmod +x /home/user/deploy.sh
```

---

## 🔁 Step 4: Run or Automate

You can run manually:

```bash
/home/user/deploy.sh
```

Or trigger it via:

- GitHub webhook
- cron job
- systemd or init script

---

## ✅ Recap

| Step | Description |
|------|-------------|
| `apk add git` | Install Git |
| `git clone` | Clone your Flask app |
| `deploy.sh` | Pull + build + restart container |

---

# 🚀 Ready for Auto Deployment!
