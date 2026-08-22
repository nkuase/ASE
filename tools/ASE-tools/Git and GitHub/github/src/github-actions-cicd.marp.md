---
marp: true
title: CI/CD with GitHub Actions
theme: default
paginate: true
---

# 🤖 Automate Deployment with GitHub Actions

Use GitHub Actions to:

- Test your code
- Build Docker images
- Deploy automatically

---

## 📁 Step 1: Create Workflow File

Create `.github/workflows/deploy.yml`

```yaml
name: Deploy Flask App

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.12'
    - name: Install dependencies
      run: pip install -r requirements.txt
    - name: Run tests
      run: pytest
```

---

## 🚢 Add Docker Build + Deploy

Extend the workflow:

```yaml
    - name: Build Docker image
      run: docker build -t my-flask-app .

    - name: Deploy to Server
      uses: appleboy/ssh-action@v1
      with:
        host: ${{ secrets.HOST }}
        username: ${{ secrets.USER }}
        key: ${{ secrets.SSH_KEY }}
        script: |
          cd ~/my-flask-app
          git pull origin main
          docker build -t flask-app .
          docker stop flask-running || true
          docker rm flask-running || true
          docker run -d --name flask-running -p 80:5000 flask-app
```

---

## 🛡️ Store Secrets in GitHub

Go to your repo → Settings → Secrets → Actions

Add:

- `HOST`: your server IP/domain
- `USER`: SSH username
- `SSH_KEY`: private key for server access

---

# ✅ CI/CD Ready with Every Push!
