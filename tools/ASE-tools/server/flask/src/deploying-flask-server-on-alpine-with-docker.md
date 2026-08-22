---
marp: true
title: Deploying Flask Server on Alpine with Docker
theme: default
paginate: true
---

# 🐳 Flask Web Server on Alpine Linux (Vultr)

**Goal:**  
Deploy a Flask app using Docker on an Alpine VPS (Virtual Private Server) 
and auto-deploy using GitHub

---
## Step 0: Check you have Docker in your System

---

## 🧰 Step 1: Install Docker on Alpine

```bash
apk update
apk add docker docker-cli
rc-update add docker boot
service docker start
```

> Make sure Docker starts on reboot.

---

## 🐍 Step 2: Create a Flask App (Locally)

**Local project structure:**

```
my-flask-app/
├── app.py
├── requirements.txt
└── Dockerfile
```

---

**`app.py`**
```python
from flask import Flask
app = Flask(__name__)
@app.route('/')
def hello():
    return "Hello from Flask!"
```

**`requirements.txt`**
```
flask
```

---

## 🐳 Step 3: Dockerfile for Flask

**`Dockerfile`**
```Dockerfile
FROM python:3.12-alpine
WORKDIR /app
COPY requirements.txt ./
RUN pip install -r requirements.txt
COPY . .
CMD ["flask", "run", "--host=0.0.0.0"]
```

---

## 📦 Step 4: Build and Run Docker Container

Make sure you are in the docker 


---

```bash
docker build -t flask-app .
docker run -d -p 80:5000 flask-app
```

> App will be available on `http://your-vultr-ip/`

---

## 🌐 Step 5: Push Code to GitHub

1. Initialize git:
```bash
git init
git remote add origin <your-repo-url>
```
---
After the initialization, run the `push_code.sh` script to push the code to github repository. 

```
git add .
git commit -m "Initial commit"
git push -u origin main
```

---

## 🤖 Step 6: Auto-Pull + Restart Script

**On Alpine server**, create this shell script:

**`/home/user/deploy.sh`**
```bash
#!/bin/sh
cd /home/deploy/my-flask-app
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

## ⚙️ Step 7: Auto Git Pull (via GitHub Webhook)

1. On your server:
```bash
apk add git busybox-suid
```
```
~ # uname -m
x86_64
```

```
wget https://github.com/adnanh/webhook/releases/latest/download/webhook-linux-amd64.tar.gz
tar -xzf webhook-linux-amd64.tar.gz
sudo -n mv webhook /usr/local/bin/
sudo -n chmod +x /usr/local/bin/webhook
```

2. Install `webhook` (Go-based tool):  
```bash
wget https://github.com/adnanh/webhook/releases/latest/download/webhook-linux-arm64.tar.gz
tar -xzf webhook-linux-arm64.tar.gz
sudo -n mv webhook /usr/local/bin/
sudo -n chmod +x /usr/local/bin/webhook
```

3. Create webhook config:

**`hooks.json`**
```json
[
  {
    "id": "flask-hook",
    "execute-command": "/home/deploy/deploy.sh",
    "command-working-directory": "/home/deploy/my-flask-app"
  }
]
```

4. Run webhook server:

```bash
webhook -hooks /home/deploy/hooks.json -port 9000 &
```

---

## 🔐 Step 8: GitHub Webhook Settings

1. Go to your GitHub repo → **Settings → Webhooks**
2. Add webhook:
   - Payload URL: `http://<your-ip>:9000/hooks/flask-hook`
   - Content Type: `application/json`
   - Secret (optional, but recommended)

---

## ✅ Done!

- Local Dev → Push to GitHub  
- GitHub Webhook → Alpine pulls + redeploys  
- Flask runs inside Docker  
- Fully automatic workflow!

---

# 🔁 Bonus: Enable on Boot

Add to `/etc/local.d/start-webhook.start`

```sh
#!/bin/sh
cd /home/user/my-flask-app
/usr/local/bin/webhook -hooks hooks.json -port 9000 &
```

Make it executable:

```bash
chmod +x /etc/local.d/start-webhook.start
rc-update add local
```

---

# 🏁 Q&A or Next Steps?

- HTTPS with Nginx + certbot
- Use Gunicorn instead of `flask run`
- Add CI/CD with GitHub Actions
