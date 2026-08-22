---
marp: true
title: Installing Docker on Local Systems
theme: default
paginate: true
---

# 🐳 Installing Docker (CLI & Desktop)

Covers setup for:

- Ubuntu Linux
- macOS
- Windows (WSL2)

---

## 🐧 1. Docker on Ubuntu Linux

### 📦 Install Docker Engine (CLI)

```bash
sudo apt update
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

Add Docker’s GPG key:

```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

---

### 🐧 Ubuntu: Add Docker Repo & Install

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
```

Enable & start Docker:

```bash
sudo systemctl enable docker
sudo systemctl start docker
```

---

### 🐧 Optional: Install Docker Desktop (GUI)

1. Download `.deb` from:  
   👉 https://www.docker.com/products/docker-desktop/

2. Install it:

```bash
sudo apt install ./docker-desktop-<version>.deb
```

3. Launch from app menu or `docker-desktop`

---

## 🍎 2. Docker on macOS

### 🧰 Install Docker Desktop (includes CLI + GUI)

1. Go to:  
👉 https://www.docker.com/products/docker-desktop/

2. Download the `.dmg` file for macOS

3. Install and drag Docker to Applications

4. Run Docker Desktop app  
✅ CLI tools like `docker` and `docker-compose` will now work in Terminal

---

### 🛠️ macOS (Optional): CLI only

Use Homebrew:

```bash
brew install docker
```

> You’ll still need **Docker Desktop** to run containers (for Docker Engine)

---

## 🪟 3. Docker on Windows (WSL2)

### 🚀 Install WSL2

```powershell
wsl --install
```

Reboot, then install Ubuntu from Microsoft Store.

---

### 🧰 Install Docker Desktop (Windows)

1. Download from:  
👉 https://www.docker.com/products/docker-desktop/

2. Install Docker Desktop

3. Enable WSL2 backend during setup

4. Start Docker Desktop  
✅ Works inside WSL terminal (`wsl`)

---

## 🧪 Verify Docker Installation

Check version:

```bash
docker --version
```

Test:

```bash
docker run hello-world
```

If you see a greeting from Docker — success! 🎉

---

## 🧩 Recap

| OS      | CLI Install | GUI Install |
|---------|-------------|--------------|
| Ubuntu  | apt + GPG   | Docker Desktop `.deb` |
| macOS   | Homebrew or Docker Desktop | Docker Desktop (recommended) |
| Windows | via WSL2    | Docker Desktop (with WSL2 backend) |

---

## 💡 Tips

- Add yourself to the `docker` group on Linux:
  ```bash
  sudo usermod -aG docker $USER
  newgrp docker
  ```

- Use Docker Desktop for Kubernetes support & GUI dashboards

- Restart your terminal after installation

---

# 🙌 You're Ready to Containerize!
