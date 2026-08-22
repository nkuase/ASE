---
marp: true
theme: default
class: lead
paginate: true
headingDivider: 2
---

# 🌀 Introduction to `curl` for API Testing

A quick guide to using `curl` for testing REST APIs from the command line.

---

## ✅ What is `curl`?

- Command-line tool to **send HTTP requests**
- Supports many protocols, mainly HTTP/S
- Excellent for **API testing and debugging**

---

## 🔧 Basic Syntax

```bash
curl [options] [URL]
```

Examples are usually focused on RESTful HTTP APIs.

---

## 📘 1. GET Request

Retrieve data from an API.

```bash
curl https://jsonplaceholder.typicode.com/posts/1
```

- Fetches post with ID = 1

---

## 📘 2. POST Request

Send JSON to create data.

```bash
curl -X POST https://jsonplaceholder.typicode.com/posts \
  -H "Content-Type: application/json" \
  -d '{"title": "foo", "body": "bar", "userId": 1}'
```

---

## 📘 3. PUT Request

Update existing resource.

```bash
curl -X PUT https://jsonplaceholder.typicode.com/posts/1 \
  -H "Content-Type: application/json" \
  -d '{"id": 1, "title": "updated", "body": "new body", "userId": 1}'
```

---

## 📘 4. DELETE Request

Delete a resource.

```bash
curl -X DELETE https://jsonplaceholder.typicode.com/posts/1
```

---

## 📘 5. Include Response Headers

Use `-i` to show response headers.

```bash
curl -i https://jsonplaceholder.typicode.com/posts/1
```

---

## 🔐 6. Send Bearer Token

Use `Authorization` header for secured APIs.

```bash
curl -H "Authorization: Bearer YOUR_TOKEN_HERE" \
     https://api.example.com/protected
```

---

## 🎯 Summary

- `curl` is a versatile HTTP client for API testing
- Supports GET, POST, PUT, DELETE
- Use headers, data, and auth for realistic testing
