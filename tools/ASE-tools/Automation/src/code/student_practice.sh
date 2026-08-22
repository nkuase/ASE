#!/bin/bash
# Make this script executable with: chmod +x student_practice.sh
# Example Script: student_practice.sh
# Purpose: Practice examples for bash introduction lecture
# Usage: chmod +x student_practice.sh && ./student_practice.sh

echo "===== Bash Practice Examples ====="
echo

# Example 1: Variables and basic operations
echo "1. Variables and Environment"
student_name="Your Name"
course="Software Engineering Tools"
echo "Student: $student_name"
echo "Course: $course"
echo "Home Directory: $HOME"
echo "Current Directory: $(pwd)"
echo

# Example 2: File operations
echo "2. File Operations Practice"
practice_dir="bash_practice_$(date +%Y%m%d)"
echo "Creating practice directory: $practice_dir"
mkdir -p "$practice_dir"
cd "$practice_dir"

# Create sample files
echo "Hello, Bash!" > greeting.txt
echo -e "apple\nbanana\ncherry\ndate" > fruits.txt
echo -e "1,John,Computer Science\n2,Jane,Mathematics\n3,Bob,Physics" > students.csv

echo "Created sample files:"
ls -la
echo

# Example 3: Text processing
echo "3. Text Processing Examples"
echo "Contents of fruits.txt:"
cat fruits.txt
echo
echo "Sorted fruits:"
sort fruits.txt
echo
echo "Fruit count: $(wc -l < fruits.txt)"
echo
echo "Students in Computer Science:"
grep "Computer Science" students.csv
echo

# Example 4: Loops and conditionals
echo "4. Control Structures"
echo "Processing all .txt files:"
for file in *.txt; do
    if [ -f "$file" ]; then
        echo "File: $file ($(wc -l < "$file") lines)"
    fi
done
echo

# Example 5: Function example
backup_file() {
    local file=$1
    if [ -f "$file" ]; then
        cp "$file" "${file}.backup"
        echo "✓ Backed up: $file"
    else
        echo "✗ File not found: $file"
    fi
}

echo "5. Function Example - Creating Backups"
backup_file "greeting.txt"
backup_file "fruits.txt"
backup_file "nonexistent.txt"
echo

# Example 6: Command substitution and pipes
echo "6. Advanced Operations"
echo "Files created in the last minute:"
find . -type f -newermt "1 minute ago"
echo
echo "File sizes:"
ls -la | awk '{print $9, $5}' | grep -v "^$"
echo

# Cleanup option
echo "Practice completed! Files created in: $(pwd)"
echo "To clean up, run: rm -rf $(pwd)"
cd ..
