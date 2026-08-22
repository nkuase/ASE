---
marp: true
theme: default
class: lead
paginate: true
title: Simple Docker Guide
---

# 🐳 Simple Docker Guide

By the end of this guide, you'll know how to:
- Understand what Docker is
- Install Docker
- Use basic Docker commands
- Run your first container

---

# What is Docker?

- Docker is a tool that makes it easier to run apps in a **container**.
- A container is like a mini-computer inside your computer.
- It includes everything an app needs to run.

🧠 Think of it like a **magic box** that runs programs the same way everywhere.

---

# Why Use Docker?

✅ No "it works on my machine" problems  
✅ Easy to install software  
✅ Great for learning programming & deploying apps

---

# Installing Docker

## Windows & macOS
1. Go to [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)
2. Download Docker Desktop
3. Install & Restart your computer

## Linux (Ubuntu example)
```bash
sudo apt update
sudo apt install docker.io
sudo systemctl start docker
sudo systemctl enable docker
```

---

# First Test: Hello World

Try this in your terminal:

```bash
docker run hello-world
```

✅ If it prints a welcome message, Docker works!

---

# Useful Docker Commands

```bash
docker images       # Show downloaded images
docker ps           # Show running containers
docker ps -a        # Show all containers
docker stop <id>    # Stop a container
docker rm <id>      # Remove a container
docker rmi <image>  # Remove an image
```

---

# Run Python in Docker

```bash
docker run -it python:3
```

➡️ This opens a Python shell inside a container. Try using `print("Hello")`.

Type `exit()` to leave.

---

# Dockerfile Example

```Dockerfile
# Save this as Dockerfile
FROM python:3
WORKDIR /app
COPY . /app
CMD ["python", "main.py"]
```

Then build and run:
```bash
docker build -t myapp .
docker run myapp
```

---

# Summary

✅ Docker runs apps in containers  
✅ Easy to install & use  
✅ Great for learning and sharing apps

---

# Resources

- [docker.com](https://www.docker.com/)
- [docs.docker.com/get-started](https://docs.docker.com/get-started)
- YouTube: "Docker in 5 Minutes"

🎓 Have fun exploring!

---

# Thank You!

🧑‍💻 Questions? Ask your TA or search online.  
You're on your way to becoming a DevOps pro!

---
