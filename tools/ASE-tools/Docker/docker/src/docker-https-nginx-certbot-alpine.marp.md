---
marp: true
title: Enable HTTPS with Docker + Nginx + Certbot (Alpine)
theme: default
paginate: true
---

# 🔐 HTTPS with Docker + Nginx + Certbot

Secure your Flask app inside Docker on Alpine using:

- Nginx (in Docker)
- Certbot for Let's Encrypt SSL
- Alpine-based lightweight containers

---

## 🧰 Step 1: Docker Compose Setup

Create `docker-compose.yml`:

```yaml
version: '3'
services:
  web:
    image: flask-app
    build: .
    expose:
      - "5000"
  nginx:
    image: nginx:alpine
    volumes:
      - ./nginx/conf:/etc/nginx/conf.d
      - ./certbot/www:/var/www/certbot
      - ./certbot/conf:/etc/letsencrypt
    ports:
      - "80:80"
      - "443:443"
    depends_on:
      - web
  certbot:
    image: certbot/certbot
    volumes:
      - ./certbot/www:/var/www/certbot
      - ./certbot/conf:/etc/letsencrypt
```

---

## ⚙️ Step 2: Nginx Config for Flask + Certbot

Create `nginx/conf/default.conf`:

```nginx
server {
    listen 80;
    server_name yourdomain.com;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        proxy_pass http://web:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

---

## 🔐 Step 3: Obtain Certificate

Run this command once:

```bash
docker compose run certbot certonly \
  --webroot -w /var/www/certbot \
  --email you@example.com \
  --agree-tos \
  --no-eff-email \
  -d yourdomain.com
```

This creates certificates in `./certbot/conf`

---

## 🔁 Step 4: Update Nginx for SSL

Update `nginx/conf/default.conf`:

```nginx
server {
    listen 443 ssl;
    server_name yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;

    location / {
        proxy_pass http://web:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

server {
    listen 80;
    server_name yourdomain.com;
    return 301 https://$host$request_uri;
}
```

---

## 🚀 Step 5: Start Everything

```bash
docker compose up -d
```

Nginx now proxies HTTPS to your Flask app running in Docker on port 5000.

---

## 🔁 Step 6: Auto Renew Certificate (cron job)

Example cron:

```bash
0 3 * * * docker compose run certbot renew && docker compose kill -s HUP nginx
```

This renews your certificate daily at 3AM and reloads Nginx.

---

## ✅ Summary

- Docker-based deployment using Nginx + Certbot
- All traffic secured with HTTPS
- Alpine images keep things lightweight

---

# 🔐 Secure Flask in Docker, Alpine-style!
