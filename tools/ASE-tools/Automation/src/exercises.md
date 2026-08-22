# Bash Exercises for Students

This file contains progressive exercises to help students practice bash skills learned in the introduction lecture.

## Level 1: Basic Commands (Beginner)

### Exercise 1.1: Navigation and File Listing
1. Navigate to your home directory
2. List all files including hidden ones
3. Create a directory called `bash_lab`
4. Navigate into the `bash_lab` directory
5. Show your current location

**Expected commands:**
```bash
cd ~
ls -la
mkdir bash_lab
cd bash_lab
pwd
```

### Exercise 1.2: File Operations
1. Create three empty files: `file1.txt`, `file2.txt`, `file3.txt`
2. Create a directory called `backup`
3. Copy all `.txt` files to the `backup` directory
4. Rename `file1.txt` to `renamed_file.txt`
5. List the contents of both current directory and `backup` directory

### Exercise 1.3: Basic Text Processing
1. Create a file called `numbers.txt` with numbers 1-10 (one per line)
2. Display the contents of the file
3. Display only the first 5 lines
4. Display only the last 3 lines
5. Count the number of lines in the file

**Hint for creating numbers.txt:**
```bash
echo -e "1\n2\n3\n4\n5\n6\n7\n8\n9\n10" > numbers.txt
```

## Level 2: Intermediate Operations

### Exercise 2.1: Text Search and Manipulation
1. Create a file called `animals.txt` with the following content:
   ```
   cat
   dog
   elephant
   cat
   bird
   dog
   fish
   elephant
   ```
2. Find all lines containing "cat"
3. Count how many times "dog" appears
4. Sort the animals alphabetically
5. Get unique animals only (no duplicates)

### Exercise 2.2: Pipes and Redirection
1. List all files in `/usr/bin` that contain "python" in the name
2. Count how many such files exist
3. Save the list to a file called `python_commands.txt`
4. Display the file size of `python_commands.txt`

### Exercise 2.3: Variables and Environment
1. Create a variable called `MY_NAME` with your name
2. Create a variable called `COURSE` with "Software Engineering"
3. Display a message: "Hello, I am [YOUR_NAME] and I'm studying [COURSE]"
4. Show your current PATH environment variable
5. Show your home directory using an environment variable

## Level 3: Scripting Basics (Intermediate)

### Exercise 3.1: Simple Script with Variables
Create a script called `greeting.sh` that:
1. Asks for the user's name (use `read` command)
2. Asks for their favorite programming language
3. Displays a personalized greeting message
4. Shows the current date and time

**Template:**
```bash
#!/bin/bash
echo "What's your name?"
read name
echo "What's your favorite programming language?"
read language
# Complete the script...
```

### Exercise 3.2: Conditional Logic
Create a script called `file_checker.sh` that:
1. Takes a filename as an argument
2. Checks if the file exists
3. If it exists, shows its size and last modification time
4. If it doesn't exist, creates an empty file with that name
5. Provides appropriate messages for each case

### Exercise 3.3: Simple Loop
Create a script called `backup_maker.sh` that:
1. Takes a directory name as an argument
2. For each `.txt` file in that directory:
   - Creates a backup copy with `.backup` extension
   - Prints a message showing what was backed up
3. Counts and displays the total number of files backed up

## Level 4: Advanced Scripting (Advanced)

### Exercise 4.1: Log Analysis Script
Create a script called `analyze_logs.sh` that processes a sample log file:

1. First, create a sample log file:
```bash
cat > sample.log << EOF
2024-01-15 10:30:15 INFO User login successful: john@example.com
2024-01-15 10:31:22 ERROR Database connection failed
2024-01-15 10:32:45 INFO User login successful: jane@example.com
2024-01-15 10:33:12 WARN High memory usage detected
2024-01-15 10:34:03 ERROR File not found: config.xml
2024-01-15 10:35:18 INFO User logout: john@example.com
2024-01-15 10:36:44 ERROR Network timeout
EOF
```

2. Your script should:
   - Count total log entries
   - Count ERROR entries
   - Count INFO entries
   - Count WARN entries
   - List all unique usernames mentioned
   - Show the time range of the logs

### Exercise 4.2: Project Setup Automation
Create a script called `setup_project.sh` that:
1. Takes a project name as an argument
2. Creates a project directory structure:
   ```
   project_name/
   ├── src/
   ├── tests/
   ├── docs/
   ├── config/
   ├── README.md
   └── .gitignore
   ```
3. Initializes a git repository in the project
4. Creates basic content in README.md with project name and creation date
5. Creates a basic .gitignore file for common file types

### Exercise 4.3: System Monitor Script
Create a script called `system_check.sh` that:
1. Shows system uptime
2. Shows available disk space (in human-readable format)
3. Shows memory usage
4. Lists the top 5 processes by CPU usage
5. Checks if specific services are running (e.g., ssh, apache)
6. Generates a timestamp for the report
7. Optionally saves the report to a file with timestamp in the filename

## Level 5: Challenge Exercises (Expert)

### Exercise 5.1: Automated Backup System
Create a comprehensive backup script that:
1. Backs up specified directories to a backup location
2. Creates compressed archives with timestamps
3. Maintains only the last 5 backups (deletes older ones)
4. Logs all operations to a log file
5. Sends a summary email (you can simulate this with echo to a file)
6. Handles errors gracefully

### Exercise 5.2: Code Quality Checker
Create a script that analyzes a code project:
1. Counts lines of code by file type (.py, .js, .java, etc.)
2. Finds files larger than a specified size
3. Looks for TODO and FIXME comments
4. Checks for files without proper headers/comments
5. Generates a quality report
6. Suggests improvements

### Exercise 5.3: Development Environment Setup
Create a script that sets up a development environment:
1. Checks if required tools are installed (git, node, python, etc.)
2. Installs missing tools (or provides instructions)
3. Sets up directory structure for projects
4. Configures git with user information
5. Creates useful aliases and environment variables
6. Downloads and sets up common configuration files

## Solutions and Help

### Getting Stuck?
1. Use `man command_name` to read about commands
2. Try `command_name --help` for quick help
3. Break complex problems into smaller steps
4. Test each part of your script individually

### Self-Check Questions
- Does my script handle errors gracefully?
- Are my variable names descriptive?
- Did I quote variables properly?
- Does my script work with different inputs?
- Is my code readable and well-commented?

### Instructor Solutions
Solutions are available in the `solutions/` directory (instructor access only).

## Submission Guidelines

### For Assignments
1. Include proper shebang (`#!/bin/bash`)
2. Add comments explaining what your script does
3. Make scripts executable (`chmod +x script.sh`)
4. Test with different inputs
5. Include error handling where appropriate

### Naming Convention
- Use descriptive names: `backup_project.sh` not `script1.sh`
- Use underscores for multi-word names
- Include `.sh` extension for clarity

## Assessment Rubric

### Beginner Level (Levels 1-2)
- **Excellent**: All exercises completed correctly with good practices
- **Good**: Most exercises completed with minor issues
- **Satisfactory**: Basic exercises completed, some help needed
- **Needs Improvement**: Struggling with basic commands

### Intermediate Level (Levels 3-4)
- **Excellent**: Scripts work correctly, include error handling, well-commented
- **Good**: Scripts work correctly with minor issues
- **Satisfactory**: Scripts work but lack polish or error handling
- **Needs Improvement**: Scripts have bugs or don't handle edge cases

### Advanced Level (Level 5)
- **Excellent**: Professional-quality scripts with comprehensive features
- **Good**: Scripts work well with most features implemented
- **Satisfactory**: Basic functionality working, some advanced features missing
- **Needs Improvement**: Significant issues with logic or implementation

---

**Remember**: The goal is learning and understanding, not just completing exercises. Take time to understand each command and concept!
