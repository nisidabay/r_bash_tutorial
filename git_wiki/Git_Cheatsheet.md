# Enhanced Git Operations Cheatsheet
# Solving Daily Mess-Ups & History Management

This guide skips the beginner setup. It focuses strictly on 
fixing mistakes,
cleaning up history, and handling branches efficiently.

**Note:** This guide uses modern Git commands introduced in 
version 2.23+ (`git restore`, `git switch`).

---

## Problem 1: "Oops, I Committed Unwanted Files!"

You typed `git add .`, committed, and realized you included 
a config or log file by mistake.
The fix depends on whether you have pushed the commit yet.

### Scenario A: It was the very last commit (Local Only)
If you haven't pushed, use a "soft reset." This deletes the 
commit itself but keeps all your file changes safely in the 
staging area.

1. Undo the commit, keep files staged:
   ```bash
   git reset --soft HEAD~1
   ```
2. Unstage the unwanted file:
   ```bash
   git restore --staged path/to/unwanted_file.txt
   ```
3. Commit the good files again:
   ```bash
   git commit -m "Your original, correct commit message"
   ```
4. (Optional) Throw away the changes in the unwanted file 
entirely:
   ```bash
   git restore path/to/unwanted_file.txt
   ```

### Scenario B: The mistake was a few commits ago
If the bad commit is buried in your history, use 
**Interactive Rebase**.
**Note:** Only do this on local branches or your private 
feature branches. Do not rewrite history on a shared branch.

1. Start the time machine (look at the last 3 commits):
   ```bash
   git rebase -i HEAD~3
   ```
   Your text editor opens. Change the word `pick` to `edit` 
next to the bad commit. Save and close.

2. When Git pauses at the bad commit, uncommit and unstage 
everything:
   ```bash
   git reset HEAD~1
   ```
   This gives you a clean slate. All files from that commit 
are now unstaged.

3. Stage only the files you actually wanted:
   ```bash
   git add path/to/good_file.txt
   ```
4. Commit the fix:
   ```bash
   git commit -m "Fix typo in header"
   ```
5. Tell Git to fast-forward back to the present:
   ```bash
   git rebase --continue
   ```

⚠️ **Critical Warning:** If you already pushed the bad 
history before fixing it, you must overwrite the remote 
history safely:
```bash
git push --force-with-lease
```
Always use `--force-with-lease` instead of `--force`. It 
prevents you from accidentally overwriting work if a 
teammate happened to push to the same branch while you were 
fixing things.

---

## Problem 2: Understanding "Rebase" (Staying Up to Date)

**Scenario:** You are working on a feature branch, but the 
main branch has moved forward with updates from your team.

- The "Messy" Way: `git merge main` creates extra merge 
commits, making history look like a spiderweb.
- The "Clean" Way: `git rebase` picks up your work, 
downloads the newest main, and pastes your work neatly on 
top of it.

1. Download the latest updates from the remote server:
   ```bash
   git fetch origin
   ```
2. Rebase your feature branch on top of main:
   ```bash
   git rebase origin/main
   ```
   If you get a conflict (Git doesn't know how to paste your 
work):
   - Git will pause. Open the conflicting files and fix the 
code.
   - Stage the fixed files:
     ```bash
     git add <fixed_file>
     ```
   - Continue the process:
     ```bash
     git rebase --continue
     ```
   **Do NOT run `git commit`.** Rebase is just applying 
existing commits; it only needs you to stage the resolution.

**Pro-Tip:** To fetch from the remote server and rebase your 
branch all in one step:
```bash
git pull --rebase
```

---

## Problem 3: Understanding "Revert" (The Safe Undo)

**Scenario:** You pushed broken code to a shared branch 
(like `main`).

**Why not use `reset`?** `git reset` erases history. If you 
erase history on a shared branch, your coworkers' computers 
will get completely confused because their history won't 
match yours anymore.

**The Fix:** `git revert`. It creates a brand new commit 
that does the exact opposite of the bad commit (e.g., if you 
added a line, it deletes it).

1. Find the hash of the bad commit:
   ```bash
   git log --oneline
   ```
2. Revert it (e.g., if the hash is `a1b2c3d`):
   ```bash
   git revert a1b2c3d
   ```
   Git opens an editor with a default message like "Revert: 
...". Save and close.
3. Push the fix:
   ```bash
   git push
   ```
   Everyone pulls this new commit. The bug is gone, and no 
one's workflow is broken.

---

## 3 More Commands to Save Your Life

### 1. `git commit --amend` (I Forgot Something!)
You just committed, but you forgot to include a file, or you 
made a typo in the message.

```bash
# Add the forgotten file to the staging area
git add forgotten_file.txt

# Add it to the previous commit silently
git commit --amend --no-edit

# OR, fix the message at the same time
git commit --amend -m "New better message"
```
**Warning:** Do not amend commits that you have already 
pushed to a shared remote.

---

### 2. `git stash` (I Need to Switch Branches Immediately)
Your boss needs a bug fix on `main` right now, but your 
current feature work is half-finished and you aren't ready 
to commit it.

```bash
# 1. Put your messy work in a temporary drawer
git stash push -m "Half-finished login feature"

# 2. Safely switch to main and fix the bug
git switch main
# ... fix bug, commit, push ...

# 3. Return to your feature branch
git switch my-feature-branch

# 4. Take your work out of the drawer
git stash pop
```
**Note:** `git stash pop` applies the saved work and deletes 
the stash. Use `git stash apply` if you want to apply the 
work but keep a backup in the stash list just in case.

---

### 3. `git reflog` (I Completely Broke Everything)
Did a bad rebase delete your work? Did you accidentally drop 
a commit? Git secretly records every single action you take, 
even if you delete commits.

```bash
# Look at the secret history
git reflog
```
Output will look something like this:
```
c4f8a9a HEAD@{0}: rebase finished
8b3c2d1 HEAD@{1}: commit: Add messy stuff (SAFE SPOT)
1a2b3c4 HEAD@{2}: checkout: moving from main to feature
```
Travel back in time to the safe spot:
```bash
git reset --hard HEAD@{1}
```
This instantly forces your branch back to exactly how it 
looked right before the disaster.

