# Claude Code Quick Reference Card

## ⚡ File Edit Strategy (Use in This Order)

### 🥇 Method 1: Bash Commands (95% success rate)
```bash
# Simple replacements
sed -i 's/pattern/replacement/g' file.dart

# Multi-line replacement
cat > file.dart << 'EOF'
complete new content here
EOF

# Insert at specific line
sed -i '10i\new line content' file.dart

# Delete line
sed -i '/pattern/d' file.dart
```

### 🥈 Method 2: Write Tool (90% success rate)
```dart
Write(
  file_path: "path/to/file.dart",
  content: "complete file content"
)
```
**Use when:** Creating new files or doing complete rewrites

### 🥉 Method 3: Edit Tool (70% success rate - USE SPARINGLY)
```dart
Read(file_path)  // Read IMMEDIATELY before edit
Edit(
  file_path: "path/to/file.dart",
  old_string: "exact string to replace",
  new_string: "replacement string"
)
```
**Use when:** Need surgical precision on complex code

## 🚫 When Edit Fails

1. **Error: "File has been unexpectedly modified"**
   - Root cause: IDE auto-formatted between Read and Edit
   - Solution: Use Bash method instead

2. **Error: "File has not been read yet"**
   - Root cause: Didn't Read file in same interaction
   - Solution: Read file, THEN Edit in same response

3. **Error: "old_string not found or not unique"**
   - Root cause: String changed or appears multiple times
   - Solution: Use more context in old_string OR use Bash

## 📋 Common Patterns

### Pattern 1: Fix Import
```bash
sed -i "s|import 'old/path.dart'|import 'new/path.dart'|g" file.dart
```

### Pattern 2: Add Method to Class
```bash
# Read file first to find insertion point
# Then use sed to insert at specific line
sed -i '/class MyClass/a\  void newMethod() {\n    // implementation\n  }' file.dart
```

### Pattern 3: Replace withOpacity
```bash
# Single file
sed -i 's/\.withOpacity(\([^)]*\))/.withValues(alpha: \1)/g' file.dart

# Multiple files
find lib -name "*.dart" -exec sed -i 's/\.withOpacity(\([^)]*\))/.withValues(alpha: \1)/g' {} \;
```

### Pattern 4: Complete File Rewrite
```bash
cat > lib/new_file.dart << 'EOFMARKER'
import 'package:flutter/material.dart';

class NewClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
EOFMARKER
```

## 🎯 Decision Tree

```
Need to modify file?
│
├─ Creating new file?
│  └─ Use: Write tool
│
├─ Simple text replacement?
│  └─ Use: sed/awk (Bash)
│
├─ Multiple similar changes?
│  └─ Use: find + sed (Bash)
│
├─ Complex surgical edit?
│  ├─ Try: Edit tool (read first!)
│  └─ Fallback: Bash if Edit fails
│
└─ Complete rewrite?
   └─ Use: cat with heredoc (Bash)
```

## ⚠️ Important Rules

1. **NEVER** use Edit without Read in same interaction
2. **ALWAYS** prefer Bash for simple changes
3. **ALWAYS** have a fallback strategy
4. **NEVER** assume Edit will work on first try
5. **ALWAYS** verify changes with Read after editing

## 🔄 Retry Pattern

```python
def modify_file():
    try:
        # Attempt 1: Edit tool
        Read(file)
        Edit(file, old, new)
    except FileModified:
        # Attempt 2: Bash sed
        bash(f"sed -i 's/{old}/{new}/g' {file}")
    except:
        # Attempt 3: Complete rewrite
        Write(file, complete_content)
```

## ✅ Success Indicators

- ✅ Bash exits with code 0
- ✅ Write tool returns success
- ✅ Edit tool doesn't throw error
- ✅ Read after change shows expected content

## 🐛 Debugging

If changes aren't appearing:
1. Check if file is open in IDE
2. Verify file path is correct
3. Check if IDE has unsaved changes
4. Try closing and reopening file in IDE

---

**Remember:** Bash commands are your friend! Use them liberally. 🎉
