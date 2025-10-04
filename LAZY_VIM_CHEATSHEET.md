# LazyVim Cheat Sheet

The most important key is the **Leader key**, which is `Space` by default. Most custom commands start by pressing `Space` first.

---

### 🚀 Essential & Getting Help

*   `<leader>l`: Open the **LazyVim** menu (plugin manager, check for updates, etc.).
*   `<leader>lk`: **List Keymaps** (shows all available keybindings).
*   `<leader>w`: **Write** (Save) the current file.
*   `<leader>q`: **Quit** the current buffer.

---

### 📄 File & Project Management

*   `<leader><space>` or `<leader>ff`: **Find File** (telescope file finder).
*   `<leader>/` or `<leader>fg`: **Find Grep** (search for text within all project files).
*   `<leader>E`: Toggle the **File Explorer** (Neo-tree).
*   `<leader>b`: **Buffers** (list and switch between open files/buffers).

---

### 💻 Window & Buffer Management

*   `<leader>c`: **Close** the current buffer.
*   `<leader>s-`: **Split** window horizontally.
*   `<leader>s|`: **Split** window vertically.
*   `[b` and `]b`: Go to the **previous** and **next** buffer.

---

### 🧠 Coding & LSP (Language Server Protocol)

*   `gd`: **Go to Definition**.
*   `gr`: **Go to References**.
*   `K`: **Hover** (shows documentation or type information for the symbol under the cursor).
*   `<leader>lr`: **Rename** symbol.
*   `<leader>ca`: **Code Actions** (e.g., auto-fix, import missing modules).
*   `]d` and `[d`: Go to the **next** and **previous** diagnostic (error/warning).

---

###  Git Integration

*   `<leader>gg`: Open **LazyGit** in a floating window (a powerful terminal UI for Git).
*   `<leader>gb`: **Git Blame** for the current line.

---

**Tip:** LazyVim uses `which-key.nvim`, so after you press `<leader>` (Space), a popup will appear showing you the available keybindings. Just wait a moment after pressing `Space` to see your options.
