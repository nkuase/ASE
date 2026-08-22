---
marp: true
title: Create a GitHub Repository from a Local Project (GUI)
theme: default
paginate: true
---

# 📦 Publish Your Local Project to GitHub (GUI)

You have a folder like:

```
~/my-flask-app
```

Now let's publish it as a **new repository on GitHub**, step-by-step using the **GitHub web GUI**.

---

## 🧑‍💻 Step 1: Go to GitHub.com

1. Login to [https://github.com](https://github.com)
2. Go to your profile (top right)
3. Click **"Your repositories"**
4. Click the green **"New"** button

---

## 🧾 Step 2: Fill in Repo Details

- **Repository name**: `my-flask-app` (or anything you like)
- **Description**: optional
- **Visibility**: choose Public or Private
- ✅ **Do NOT check "Initialize with README"** (you already have files)

Click **Create repository**

---

## 🧰 Step 3: Copy the Remote URL

After creating the repo, GitHub shows setup instructions.

Copy the **"HTTPS"** URL:  
Example:

```
https://github.com/make2grow/my-flask-app.git
```

---

## 🛠️ Step 4: Push from Local Folder

Now go to your terminal:

```bash
cd ~/my-flask-app

git init
git remote add origin https://github.com/make2grow/my-flask-app.git
git add .
git commit -m "Initial commit"
git branch -M main
git push -u origin main
```
---

```
smcho@m4 my-flask-app> git config user.name make2grow
smcho@m4 my-flask-app> git config user.email make2gr@gmail.com
smcho@m4 my-flask-app> git push -u origin main
remote: Permission to make2grow/my-flask-app.git denied to nkuase.
fatal: unable to access 'https://github.com/make2grow/my-flask-app.git/': The requested URL returned error: 403
```
You need to run this command to change protocol:

```
git remote set-url origin git@make2grow:make2grow/my-flask-app.git
```

---

## ✅ Done!

Your local folder is now a GitHub repository.

You can view it at:

```
https://github.com/make2grow/my-flask-app
```

and pull/push from any machine.

---

## 🔄 Next Steps

- Set up GitHub webhooks for auto-deploy
- Invite collaborators
- Enable issues or wikis
- Add a README or LICENSE

---

# 🚀 Project is now version-controlled and online!
