# Claude Code File Editing Guide

## Problem: "File has been unexpectedly modified" Errors

This occurs when the IDE auto-formats files between Claude Code's Read and Edit operations.

## Solutions Implemented

### 1. VS Code Settings (settings.json)
- Extended auto-save delay to 5 seconds
- Disabled format-on-type for Dart
- Configured proper file watchers

### 2. Best Practices for Claude Code

#### ✅ When to Use Each Tool

**Use BASH for simple content replacement:**
```bash
# For small, deterministic changes
sed -i 's/old_pattern/new_pattern/g' file.dart
```

**Use Write tool for new files or complete rewrites:**
```bash
# When creating new files
Write tool with full content
```

**Use Edit tool with caution:**
```bash
# Only when:
# 1. The change is small and specific
# 2. You just read the file in the same interaction
# 3. No auto-formatting is expected
```

#### 🔄 Retry Strategy

If "File has been unexpectedly modified" error occurs:

1. **First attempt**: Use Edit tool normally
2. **Second attempt**: Read file again immediately before Edit
3. **Third attempt**: Use Bash with sed/awk for the change
4. **Fourth attempt**: Create new file with Write tool, then replace

#### 🎯 Foolproof Pattern

```python
# Best practice: Single operation workflow
1. Read file (if needed)
2. Immediately perform EITHER:
   - Write (for new/complete rewrite)
   - Bash sed/awk (for simple replacements)
   - Edit (for complex changes, but risky)
```

### 3. Alternative Approaches

#### Option A: Disable Auto-Format Temporarily
```json
// In settings.json, set:
"editor.formatOnSave": false
```

#### Option B: Use Bash Commands
```bash
# More reliable for simple edits
cat > file.dart << 'EOF'
[entire new content]
EOF
```

#### Option C: Pre-format Before Edit
```bash
# Format file first, then edit
dart format file.dart
# Now Edit tool will work better
```

## Current Project Configuration

- Auto-save delay: 5000ms (5 seconds)
- Format on save: Enabled (but with delay)
- Format on type: Disabled for Dart
- Hot exit: On exit and window close

## Recommendations

1. **For Claude Code**: Prefer Bash commands or Write tool over Edit tool
2. **For user**: Can temporarily disable format-on-save when Claude is working
3. **For complex edits**: Break into smaller, atomic changes
