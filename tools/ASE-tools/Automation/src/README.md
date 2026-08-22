# Bash Introduction - Teaching Materials

This directory contains materials for teaching bash fundamentals to university students in the Software Engineering Tools course.

## Contents

### 1. `bash-introduction.md`
- Marp presentation covering bash fundamentals
- Designed for university-level students
- Includes real-world examples and best practices

### 2. `student_practice.sh`
- Hands-on practice script for students
- Demonstrates key concepts from the lecture
- Safe to run with automatic cleanup options

### 3. `exercises.md`
- Practice exercises for students
- Progressive difficulty levels
- Solutions provided for instructors

## How to Use

### For Instructors

#### Presenting the Slides
1. Install Marp CLI or use Marp for VS Code
2. Open `bash-introduction.md` in Marp
3. Present or export to PDF/HTML

```bash
# Using Marp CLI
npm install -g @marp-team/marp-cli
marp bash-introduction.md --pdf
marp bash-introduction.md --html
```

#### During Class
1. Present the slides interactively
2. Demonstrate commands live in terminal
3. Have students run `student_practice.sh`
4. Assign exercises from `exercises.md`

### For Students

#### Prerequisites
- Access to terminal (macOS Terminal, Linux terminal, or WSL on Windows)
- Basic computer literacy

#### Getting Started
1. Download or clone these materials
2. Open terminal and navigate to this directory
3. Follow along with the presentation
4. Run the practice script:

```bash
chmod +x student_practice.sh
./student_practice.sh
```

#### Practice Exercises
1. Complete exercises in `exercises.md`
2. Start with Level 1 (Beginner)
3. Progress through levels as you become comfortable

## Learning Objectives

After completing this module, students should be able to:

- [ ] Navigate the file system using command line
- [ ] Perform basic file operations (create, copy, move, delete)
- [ ] Use pipes and redirection for text processing
- [ ] Write simple bash scripts with variables and control structures
- [ ] Apply bash skills to automate common development tasks
- [ ] Follow best practices for shell scripting

## Additional Resources

### Online Learning
- [Bash Manual](https://www.gnu.org/software/bash/manual/)
- [ShellCheck](https://www.shellcheck.net/) - Script validation tool
- [Explain Shell](https://explainshell.com/) - Command explanation tool

### Practice Platforms
- [OverTheWire - Bandit](https://overthewire.org/wargames/bandit/) - Linux command line game
- [HackerRank - Linux Shell](https://www.hackerrank.com/domains/shell)
- [Codewars - Shell](https://www.codewars.com/)

## Assessment Ideas

### Formative Assessment
- Live coding during class
- Peer programming exercises
- Quick command challenges

### Summative Assessment
- Script writing assignments
- Automation project
- Command line proficiency test

## Troubleshooting

### Common Student Issues

1. **Permission denied errors**
   ```bash
   chmod +x script_name.sh
   ```

2. **Command not found**
   - Check if command exists: `which command_name`
   - Verify PATH: `echo $PATH`

3. **Script doesn't run**
   - Check shebang line: `#!/bin/bash`
   - Make executable: `chmod +x script.sh`
   - Run with: `./script.sh`

### Getting Help
- Use `man command_name` for command documentation
- Use `command_name --help` for quick help
- Check online resources listed above

## Course Integration

This module fits well in:
- **Week 3-4** of Software Engineering Tools course
- **Before** covering advanced automation tools
- **After** basic programming concepts
- **Alongside** version control (Git) introduction

## Feedback and Improvements

Please provide feedback on:
- Presentation clarity and pace
- Exercise difficulty levels
- Additional examples needed
- Technical accuracy

---

**Instructor**: [Your Name]  
**Course**: Software Engineering Tools - Automation  
**Last Updated**: $(date)
