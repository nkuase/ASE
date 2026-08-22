---
marp: true
theme: default
class: lead
paginate: true
headingDivider: 2
---

# 🚀 Introduction to Postman for API Testing

A beginner-friendly overview of using **Postman** to test APIs.

---

## 🧰 What is Postman?

- A GUI tool for testing RESTful APIs
- Allows sending HTTP requests without writing code
- Useful for developers, testers, and API consumers

---

## 🎯 Why Use Postman?

- User-friendly interface
- Supports all HTTP methods
- Easily manage collections, environments, and tests
- Generate code snippets in multiple languages

---

## 📦 Sending a GET Request

1. Open Postman
2. Choose `GET` method
3. Enter URL (e.g. `https://jsonplaceholder.typicode.com/posts/1`)
4. Click **Send**

✅ You will see the response body, headers, status code.

---

## 📝 Sending a POST Request

1. Choose `POST` method
2. Enter URL (e.g. `https://jsonplaceholder.typicode.com/posts`)
3. Go to **Body** tab
4. Select **raw** and choose **JSON**
5. Paste JSON data:
```json
{
  "title": "foo",
  "body": "bar",
  "userId": 1
}
```
6. Click **Send**

---

## 🔁 PUT and DELETE Requests

- Same steps as POST
- Choose `PUT` or `DELETE` method
- Provide appropriate URL and JSON payload (if needed)

---

## 🔐 Authorization

- Go to **Authorization** tab
- Choose **Bearer Token**
- Paste your token
- Headers are automatically added

---

## ⚙️ Environment Variables

- Define variables like `{{base_url}}`
- Use them in requests to avoid repetition
- Great for switching between dev/staging/prod

---

## 📚 Collections

- Group related requests into **Collections**
- Add descriptions, folders, and tests
- Share or export collections for team collaboration

---

## 🧪 Tests and Scripts

- Add JavaScript tests under **Tests** tab
- Example:
```js
pm.test("Status code is 200", () => {
  pm.response.to.have.status(200);
});
```
- Great for automation and validation

---

## 📤 Exporting & Sharing

- Export collections as JSON files
- Share via Postman Cloud
- Generate documentation automatically

---

## 🎯 Summary

- Postman is a powerful tool for API testing
- Simplifies sending requests, testing, and collaboration
- Ideal for manual and automated API testing workflows
