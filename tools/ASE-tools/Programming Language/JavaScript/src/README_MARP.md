# LaTeX to Marp Conversion Guide

This directory contains your LaTeX Beamer presentations converted to Marp markdown format.

## What is Marp?

Marp (Markdown Presentation Ecosystem) is a modern tool for creating presentations using Markdown. It's simpler than LaTeX and produces clean, professional slides.

## Converted Files

- ✅ **SE_programming_javascript.md** - JavaScript programming concepts
- ⏳ **SE_programming_nodejs.md** - Node.js (pending)
- ⏳ **SE_programming_advjs_async.md** - Async/Await (pending)
- ⏳ **SE_programming_advjs_module.md** - Modules (pending)
- ⏳ **SE_programming_advjs_tests.md** - Unit Tests (pending)

## How to Use Marp Slides

### Method 1: VS Code Extension (Recommended for Editing)

1. **Install VS Code Extension**
   - Open VS Code
   - Go to Extensions (Ctrl+Shift+X)
   - Search for "Marp for VS Code"
   - Install the extension by Marp Team

2. **View Presentations**
   - Open any `.md` file
   - Click the preview icon (top right) or press `Ctrl+K V`
   - Use arrow keys to navigate slides

3. **Export Presentations**
   - Right-click in the editor
   - Select "Marp: Export slide deck..."
   - Choose format: HTML, PDF, or PPTX

### Method 2: Marp CLI (For Batch Processing)

1. **Install Marp CLI**
   ```bash
   npm install -g @marp-team/marp-cli
   ```

2. **Present Slides**
   ```bash
   # Preview in browser
   marp -p SE_programming_javascript.md
   
   # Watch mode (auto-reload)
   marp -w -p SE_programming_javascript.md
   ```

3. **Export to Different Formats**
   ```bash
   # Export to PDF
   marp SE_programming_javascript.md --pdf
   
   # Export to PowerPoint
   marp SE_programming_javascript.md --pptx
   
   # Export to HTML
   marp SE_programming_javascript.md --html
   
   # Export all markdown files
   marp *.md --pdf
   ```

### Method 3: Online Marp Editor

1. Go to https://marp.app/
2. Copy and paste the markdown content
3. Preview and download

## Marp Features Used in Converted Files

### Basic Structure
```markdown
---
marp: true
theme: default
paginate: true
---

# Title Slide
Content

---

## Section Slide
Content
```

### Two-Column Layout
```markdown
<div class="columns">
<div>
Left column content
</div>
<div>
Right column content
</div>
</div>
```

### Code Blocks
````markdown
```javascript
function hello() {
  console.log("Hello");
}
```
````

### Images
```markdown
![](path/to/image.png)
```

## Customizing Themes

### Built-in Themes
- `default` - Clean, professional theme (currently used)
- `gaia` - Modern, colorful theme
- `uncover` - Minimalist theme

To change theme, modify the header:
```markdown
---
theme: gaia
---
```

### Custom Styling
Add custom CSS in the style section:
```markdown
---
style: |
  section {
    font-size: 30px;
  }
  h1 {
    color: #ff0000;
  }
---
```

## Tips for Teaching

1. **Interactive Mode**: Use `marp -p` for live presentations with speaker notes
2. **Print Handouts**: Export to PDF and print with multiple slides per page
3. **Student Access**: Export to HTML and share via web or LMS
4. **Code Examples**: All code blocks have syntax highlighting
5. **Progressive Disclosure**: Use fragments for step-by-step reveals (add `<!-- fit -->` comments)

## Converting Remaining Files

To convert the remaining LaTeX files to Marp:

1. **Option A**: Ask Claude to convert each file
   ```
   "Please convert SE_programming_nodejs.tex to Marp format"
   ```

2. **Option B**: Use the conversion script
   ```bash
   chmod +x convert_to_marp.sh
   ./convert_to_marp.sh
   ```

## Conversion Notes

### What Was Converted:
- ✅ Frame titles → Slide headers (##)
- ✅ Itemize → Markdown bullets (-)
- ✅ Code listings → Code blocks with syntax highlighting
- ✅ Two-column layouts → CSS grid columns
- ✅ Images → Markdown image syntax
- ✅ Bold/italic → Markdown formatting

### Known Limitations:
- Complex LaTeX math needs manual adjustment
- Some custom Beamer themes may need CSS tweaking
- Animations require manual implementation
- Image paths may need adjustment

## Quick Reference

| LaTeX Command | Marp Equivalent |
|---------------|-----------------|
| `\begin{frame}{Title}` | `## Title` |
| `\begin{itemize} \item` | `- ` (bullet) |
| `\begin{lstlisting}` | ` ```language ` |
| `\textbf{text}` | `**text**` |
| `\textit{text}` | `*text*` |
| `\includegraphics{file}` | `![](file)` |

## Troubleshooting

### Images Not Showing
- Check image paths are relative to the .md file
- Ensure images exist in the specified directories
- Use forward slashes `/` in paths

### Code Not Highlighting
- Specify language: ` ```javascript ` not just ` ``` `
- Supported languages: javascript, python, java, html, css, etc.

### Slides Not Rendering
- Ensure `---` separator between slides
- Check for syntax errors in YAML frontmatter
- Validate markdown syntax

## Resources

- [Marp Official Documentation](https://marp.app/)
- [Marp CLI Documentation](https://github.com/marp-team/marp-cli)
- [Markdown Guide](https://www.markdownguide.org/)
- [VS Code Marp Extension](https://marketplace.visualstudio.com/items?itemName=marp-team.marp-vscode)

## Support

For questions about:
- Marp syntax: Check official documentation
- Conversion issues: Ask Claude for help
- Course content: Contact Dr. Samuel Cho

---

**Last Updated**: October 2, 2025  
**Status**: 1 of 5 files converted
