---
marp: true
title: Why Add Docker's APT Repository?
theme: default
paginate: true
---

# 📦 Why Add Docker's Repository on Ubuntu?

When installing Docker on Ubuntu, we add Docker's official APT repository.

---

## 🧠 The Purpose

Ubuntu's default packages are often:

- 🔸 **Outdated** versions of Docker
- 🔸 Missing security patches or new features

By adding Docker's repository, we can:

✅ Get the **latest stable version**  
✅ Install `docker-ce`, `docker-ce-cli`, `containerd.io`  
✅ Use official signed packages

---

## 🧾 The Command

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

---

## 🔍 Breaking It Down

| Part | What it does |
|------|--------------|
| `dpkg --print-architecture` | Gets system arch (e.g., amd64) |
| `lsb_release -cs` | Gets Ubuntu version code name (e.g., focal, jammy) |
| `signed-by=...` | Ensures packages are verified by Docker's GPG key |
| `tee` | Writes the line to `docker.list` with sudo |
| `> /dev/null` | Hides output from the terminal |

---

## 🧪 If You Skip This Step

```bash
sudo apt install docker-ce
```

⛔ Error: "Unable to locate package docker-ce"

Because Ubuntu doesn’t know where to find Docker unless you add this repository!

---

## ✅ Summary

- This command **registers Docker’s official APT repository**
- It's a **one-time setup**
- Required to install and update **official Docker packages**

---

# 🐳 You're Ready to Install Docker!
