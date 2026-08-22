---
marp: true
html: true
size: 4:3
paginate: true
style: |
  strong {
    text-shadow: 1px 1px 0px #000000;
  }
  @media print {
    strong {
      text-shadow: none !important;
      -webkit-text-stroke: 0.6px rgba(0,0,0,0.35);
      text-stroke: 0.6px rgba(0,0,0,0.35); /* ignored by many, harmless */
    }
  }
  img[alt~="center"] {
    display: block;
    margin: 0 auto;
  }
    img[alt~="outline"] {
    border: 2px solid #388bee;
  }
  .columns {
    display: flex;
    gap: 2rem;
  }
  .column {
    flex: 1;
  }
---

<!-- _class: lead -->
<!-- _class: frontpage -->
<!-- _paginate: skip -->

# Marp: Making Presentation Slides using Markdown

---

## What is Marp?

- Marp is a compiler that transforms the markdown text file into presentation file formats, such as PPT, PDF, and HTML.
- This PDF file is made with Marp, and you should be able to read the marp source file (2_marp.md) using VSCode & Marp extension.

---

![w:600pt center](./pic/marp/vscode.jpeg)

---

## Installation of Marp Extension

<div class="columns">
  <div class="column">

![w:100pt center](./pic/marp/marp1.png)

  </div>
  <div class="column">

- From the Extensions sidebar, choose Marp.

  </div>

</div>

---

## Read Marp Files

<div class="columns">
  <div class="column">

![w:400pt center](./pic/marp/marp2.webp)

  </div>
  <div class="column">

- Choose the marp file (.md file) to read, and click the Marp Preview button.

  </div>

</div>

---

## Convert Marp Files to HTML/PDF/PPT

1. Choose the converter menu. ![w:100pt center](./pic/marp/marp3.png)

2. Choose "Export Slide Deck".

![w:300pt center](./pic/marp/marp4.png)

3. Choose the format that you want to convert.

![w:300pt center](./pic/marp/marp5.png)

---

## For the ASE courses

1. When reading MD (Marp/Markdown format) files (homework or project files), use VSCode and the preview menu to read the files.
2. When reading PDF files, you can use the `VSCode PDF extension` to read the PDF files.
3. When making code, you can use any programming extensions, and use the terminal to compile & run code.

In short, you can use VSCode to complete any ASE course activity.

---

## Exercise

This directory has all the Marp source files.

- Use VSCode and the Marp extension to read markdown files.
- Use them to convert the Marp (md) files into PDF files.
