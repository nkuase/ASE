#!/usr/bin/env node

/**
 * LaTeX Beamer to Marp Converter
 * Converts LaTeX beamer presentations to Marp markdown format
 */

const fs = require('fs');
const path = require('path');

class LatexToMarpConverter {
    constructor(basePath) {
        this.basePath = basePath;
        this.imageBasePath = '';
    }

    /**
     * Main conversion function for a tex file
     */
    convertFile(inputPath, outputPath) {
        console.log(`Converting ${inputPath} to ${outputPath}...`);
        
        try {
            const content = fs.readFileSync(inputPath, 'utf8');
            const marpContent = this.convertLatexToMarp(content, inputPath);
            
            fs.writeFileSync(outputPath, marpContent, 'utf8');
            console.log(`✓ Successfully converted to ${outputPath}`);
            return true;
        } catch (error) {
            console.error(`✗ Error converting ${inputPath}:`, error.message);
            return false;
        }
    }

    /**
     * Convert LaTeX content to Marp markdown
     */
    convertLatexToMarp(content, filePath) {
        let marpContent = this.generateMarpHeader();
        
        // Extract title, author, date
        const titleMatch = content.match(/\\title\[.*?\]\{(.*?)\}/s);
        const authorMatch = content.match(/\\author\{(.*?)\}/);
        const dateMatch = content.match(/\\date\{(.*?)\}/);
        
        if (titleMatch) {
            const title = this.cleanLatex(titleMatch[1]);
            marpContent += `\n# ${title}\n\n`;
            if (authorMatch) {
                marpContent += `**${this.cleanLatex(authorMatch[1])}**\n\n`;
            }
            if (dateMatch) {
                marpContent += `${this.cleanLatex(dateMatch[1])}\n\n`;
            }
        }

        // Extract sections and their content files
        const inputMatches = [...content.matchAll(/\\input\{(.*?)\}/g)];
        const sectionMatches = [...content.matchAll(/\\def\\(?:title|name)\{(.*?)\}[\s\S]*?\\section/g)];
        
        // Add table of contents if sections exist
        if (sectionMatches.length > 0) {
            marpContent += `---\n\n# Table of Contents\n\n`;
            sectionMatches.forEach((match, index) => {
                const sectionTitle = this.cleanLatex(match[1]);
                marpContent += `${index + 1}. ${sectionTitle}\n`;
            });
            marpContent += `\n`;
        }

        // Process each input file
        inputMatches.forEach((match, index) => {
            const inputFile = match[1] + '.tex';
            const fullPath = path.join(this.basePath, inputFile);
            
            if (fs.existsSync(fullPath)) {
                const sectionTitle = sectionMatches[index] ? this.cleanLatex(sectionMatches[index][1]) : '';
                if (sectionTitle) {
                    marpContent += `---\n\n# ${sectionTitle}\n\n`;
                }
                
                const frameContent = fs.readFileSync(fullPath, 'utf8');
                marpContent += this.convertFrames(frameContent);
            } else {
                console.warn(`Warning: File not found: ${fullPath}`);
            }
        });

        return marpContent;
    }

    /**
     * Generate Marp header with theme and settings
     */
    generateMarpHeader() {
        return `---
marp: true
theme: default
paginate: true
backgroundColor: #fff
style: |
  section {
    font-size: 28px;
  }
  h1 {
    color: #0066cc;
  }
  code {
    background-color: #f4f4f4;
  }
---

`;
    }

    /**
     * Convert LaTeX frames to Marp slides
     */
    convertFrames(content) {
        let result = '';
        const frames = this.extractFrames(content);
        
        frames.forEach(frame => {
            result += this.convertFrame(frame);
        });
        
        return result;
    }

    /**
     * Extract individual frames from content
     */
    extractFrames(content) {
        const frames = [];
        const frameRegex = /\\begin\{frame\}(?:\[.*?\])?\{?(.*?)\}?(.*?)\\end\{frame\}/gs;
        let match;
        
        while ((match = frameRegex.exec(content)) !== null) {
            frames.push({
                title: match[1],
                content: match[2]
            });
        }
        
        return frames;
    }

    /**
     * Convert a single frame to Marp slide
     */
    convertFrame(frame) {
        let slide = '---\n\n';
        
        // Add title if exists
        if (frame.title && frame.title.trim()) {
            const title = this.cleanLatex(frame.title);
            if (title) {
                slide += `## ${title}\n\n`;
            }
        }
        
        // Convert content
        let content = frame.content;
        
        // Convert itemize to markdown bullets
        content = this.convertItemize(content);
        
        // Convert enumerate to numbered list
        content = this.convertEnumerate(content);
        
        // Convert code listings
        content = this.convertCodeListings(content);
        
        // Convert images
        content = this.convertImages(content);
        
        // Convert columns
        content = this.convertColumns(content);
        
        // Clean up remaining LaTeX commands
        content = this.cleanLatex(content);
        
        slide += content + '\n\n';
        
        return slide;
    }

    /**
     * Convert itemize environment to markdown bullets
     */
    convertItemize(content) {
        // Replace itemize environment
        content = content.replace(/\\begin\{itemize\}(.*?)\\end\{itemize\}/gs, (match, items) => {
            let result = '';
            const itemRegex = /\\item\s+(.*?)(?=\\item|$)/gs;
            let itemMatch;
            
            while ((itemMatch = itemRegex.exec(items)) !== null) {
                let item = itemMatch[1].trim();
                // Remove trailing whitespace and newlines
                item = item.replace(/\s*\\end\{itemize\}.*/s, '');
                if (item) {
                    result += `- ${item}\n`;
                }
            }
            
            return result;
        });
        
        return content;
    }

    /**
     * Convert enumerate environment to numbered list
     */
    convertEnumerate(content) {
        content = content.replace(/\\begin\{enumerate\}(.*?)\\end\{enumerate\}/gs, (match, items) => {
            let result = '';
            const itemRegex = /\\item\s+(.*?)(?=\\item|$)/gs;
            let itemMatch;
            let index = 1;
            
            while ((itemMatch = itemRegex.exec(items)) !== null) {
                let item = itemMatch[1].trim();
                item = item.replace(/\s*\\end\{enumerate\}.*/s, '');
                if (item) {
                    result += `${index}. ${item}\n`;
                    index++;
                }
            }
            
            return result;
        });
        
        return content;
    }

    /**
     * Convert lstlisting to markdown code blocks
     */
    convertCodeListings(content) {
        // Convert lstlisting
        content = content.replace(/\\begin\{lstlisting\}(?:\[.*?\])?(.*?)\\end\{lstlisting\}/gs, (match, code) => {
            // Detect language from context or use javascript as default
            let language = 'javascript';
            if (code.includes('import') || code.includes('require')) {
                language = 'javascript';
            } else if (code.includes('<html') || code.includes('<div')) {
                language = 'html';
            } else if (code.includes('def ') || code.includes('import ')) {
                language = 'python';
            }
            
            code = code.trim();
            return `\n\`\`\`${language}\n${code}\n\`\`\`\n`;
        });
        
        // Convert Code environment
        content = content.replace(/\\begin\{Code\}(?:\{.*?\})?(.*?)\\end\{Code\}/gs, (match, code) => {
            let innerCode = code.match(/\\begin\{lstlisting\}(?:\[.*?\])?(.*?)\\end\{lstlisting\}/s);
            if (innerCode) {
                let cleanCode = innerCode[1].trim();
                return `\n\`\`\`javascript\n${cleanCode}\n\`\`\`\n`;
            }
            return code;
        });
        
        // Convert inline verbatim
        content = content.replace(/\\verb\|(.*?)\|/g, '`$1`');
        
        return content;
    }

    /**
     * Convert images
     */
    convertImages(content) {
        content = content.replace(/\\includegraphics(?:\[.*?\])?\{(.*?)\}/g, (match, imagePath) => {
            // Clean up the path
            imagePath = imagePath.replace(/topics\/SE_programming\//, '');
            return `![](${imagePath})`;
        });
        
        return content;
    }

    /**
     * Convert columns to Marp two-column layout
     */
    convertColumns(content) {
        content = content.replace(/\\begin\{columns\}(?:%?)?(.*?)\\end\{columns\}(?:%?)?/gs, (match, columnsContent) => {
            const columns = [];
            const columnRegex = /\\begin\{column\}\{.*?\}(?:%?)?(.*?)\\end\{column\}(?:%?)?/gs;
            let colMatch;
            
            while ((colMatch = columnRegex.exec(columnsContent)) !== null) {
                columns.push(colMatch[1].trim());
            }
            
            if (columns.length === 2) {
                return `\n<div class="columns">\n<div class="column">\n\n${columns[0]}\n\n</div>\n<div class="column">\n\n${columns[1]}\n\n</div>\n</div>\n`;
            } else if (columns.length > 0) {
                return columns.join('\n\n');
            }
            
            return columnsContent;
        });
        
        return content;
    }

    /**
     * Clean LaTeX commands and convert to plain text/markdown
     */
    cleanLatex(text) {
        if (!text) return '';
        
        // Remove comments
        text = text.replace(/%.*/g, '');
        
        // Convert text formatting
        text = text.replace(/\\textbf\{(.*?)\}/g, '**$1**');
        text = text.replace(/\\textit\{(.*?)\}/g, '*$1*');
        text = text.replace(/\\emph\{(.*?)\}/g, '*$1*');
        text = text.replace(/\\underbar\{(.*?)\}/g, '<u>$1</u>');
        text = text.replace(/\\underline\{(.*?)\}/g, '<u>$1</u>');
        
        // Convert line breaks
        text = text.replace(/\\\\/g, '\n');
        text = text.replace(/\\newline/g, '\n');
        
        // Remove common LaTeX commands
        text = text.replace(/\\(?:usebeamerfont|usebeamercolor|frametitle|begin\{center\}|end\{center\})/g, '');
        text = text.replace(/\\[a-zA-Z]+\*?(?:\[.*?\])?\{.*?\}/g, (match) => {
            // Extract content from command
            const contentMatch = match.match(/\{(.*?)\}$/);
            return contentMatch ? contentMatch[1] : '';
        });
        
        // Remove remaining backslashes
        text = text.replace(/\\(?=[a-zA-Z])/g, '');
        
        // Clean up whitespace
        text = text.replace(/\s+/g, ' ').trim();
        
        return text;
    }

    /**
     * Convert all tex files in the directory
     */
    convertAllFiles() {
        const files = [
            'SE_programming_javascript.tex',
            'SE_programming_advjs_async.tex',
            'SE_programming_advjs_module.tex',
            'SE_programming_advjs_tests.tex',
            'SE_programming_nodejs.tex'
        ];

        let successCount = 0;
        let failCount = 0;

        files.forEach(file => {
            const inputPath = path.join(this.basePath, file);
            const outputPath = path.join(this.basePath, file.replace('.tex', '.md'));
            
            if (fs.existsSync(inputPath)) {
                if (this.convertFile(inputPath, outputPath)) {
                    successCount++;
                } else {
                    failCount++;
                }
            } else {
                console.warn(`Warning: File not found: ${inputPath}`);
                failCount++;
            }
        });

        console.log(`\n=== Conversion Summary ===`);
        console.log(`✓ Successful: ${successCount}`);
        console.log(`✗ Failed: ${failCount}`);
        console.log(`Total: ${files.length}`);
    }
}

// Main execution
if (require.main === module) {
    const basePath = process.argv[2] || __dirname;
    const converter = new LatexToMarpConverter(basePath);
    
    console.log('LaTeX to Marp Converter');
    console.log('=======================\n');
    console.log(`Base path: ${basePath}\n`);
    
    converter.convertAllFiles();
}

module.exports = LatexToMarpConverter;
