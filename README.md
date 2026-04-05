# Neovim Keymap Reference

> **Leader key:** `<Space>`

---

## Window Management

| Key | Action |
|-----|--------|
| `<leader>sv` | Split window vertically |
| `<leader>sh` | Split window horizontally |
| `<leader>se` | Make splits equal size |
| `<leader>sx` | Close current split |
| `<C-h>` | Move to left split |
| `<C-j>` | Move to lower split |
| `<C-k>` | Move to upper split |
| `<C-l>` | Move to right split |

---

## Tabs & Buffers

| Key | Action |
|-----|--------|
| `tn` | Next tab |
| `tp` | Previous tab |
| `<leader>th` / `<leader>tj` | Previous buffer (bufferline) |
| `<leader>tk` / `<leader>tl` | Next buffer (bufferline) |
| `<leader>tx` | Close current buffer |

---

## File Explorer (nvim-tree)

| Key | Action |
|-----|--------|
| `<leader>ex` | Toggle file explorer |
| `<leader>er` | Refresh file explorer |

---

## Telescope (Fuzzy Finder)

| Key | Action |
|-----|--------|
| `<C-p>` | Find files |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Browse open buffers |
| `<leader>fh` | Search help tags |

---

## LSP — Navigation & Actions

> These keymaps are buffer-local and active whenever an LSP server attaches.

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | List references |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>gd` | Go to definition (alt) |
| `<leader>gD` | Go to declaration (alt) |

---

## LSP — Diagnostics

| Key | Action |
|-----|--------|
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<leader>e` | Show diagnostic float |
| `<leader>q` | Send diagnostics to loclist |

---

## Trouble (Diagnostics Panel)

| Key | Action |
|-----|--------|
| `<leader>xx` | Toggle diagnostics panel |
| `<leader>xX` | Toggle buffer diagnostics |
| `<leader>cs` | Toggle symbols panel |
| `<leader>cl` | Toggle LSP panel (right) |
| `<leader>xL` | Toggle location list |
| `<leader>xQ` | Toggle quickfix list |

---

## Go-to Preview (Peek Windows)

| Key | Action |
|-----|--------|
| `<leader>pd` | Preview definition |
| `<leader>pi` | Preview implementation |
| `<leader>pr` | Preview references |
| `<leader>pc` | Close all preview windows |
| `q` | Close preview window (inside preview) |

---

## Symbol Navigation

| Key | Action |
|-----|--------|
| `<leader>o` | Toggle Outline panel |
| `<leader>a` | Toggle Aerial panel |
| `{` | Previous symbol (Aerial) |
| `}` | Next symbol (Aerial) |

---

## Git (Gitsigns)

| Key | Mode | Action |
|-----|------|--------|
| `]c` | Normal | Next hunk |
| `[c` | Normal | Previous hunk |
| `<leader>hs` | Normal / Visual | Stage hunk |
| `<leader>hr` | Normal / Visual | Reset hunk |
| `<leader>hS` | Normal | Stage entire buffer |
| `<leader>hu` | Normal | Undo stage hunk |
| `<leader>hR` | Normal | Reset entire buffer |
| `<leader>hp` | Normal | Preview hunk |
| `<leader>hb` | Normal | Blame line (full) |
| `<leader>hd` | Normal | Diff this |
| `<leader>hD` | Normal | Diff this `~` |
| `<leader>tb` | Normal | Toggle inline blame |
| `<leader>td` | Normal | Toggle deleted lines |
| `ih` | Operator / Visual | Select hunk (text object) |

---

## Flash (Motion)

| Key | Mode | Action |
|-----|------|--------|
| `s` | Normal / Visual / Operator | Flash jump |
| `S` | Normal / Visual / Operator | Flash treesitter jump |
| `r` | Operator | Remote flash |
| `R` | Operator / Visual | Treesitter search |
| `<C-s>` | Command | Toggle flash search |

---

## Autocompletion (nvim-cmp)

| Key | Action |
|-----|--------|
| `<C-Space>` | Trigger completion menu |
| `<C-e>` | Abort / close menu |
| `<CR>` | Confirm selected item |
| `<Tab>` | Next item / expand or jump snippet |
| `<S-Tab>` | Previous item / jump back in snippet |
| `<C-d>` | Scroll docs up |
| `<C-f>` | Scroll docs down |

---

## LSP Signature (Function Hints)

| Key | Action |
|-----|--------|
| `<M-x>` | Toggle signature hint window |
| `<M-n>` | Cycle to next signature overload |

---

## Reference Panel (custom)

| Key | Action |
|-----|--------|
| `<leader>rp` | Pick & toggle reference file panel |
| `<leader>rj` | Scroll reference panel down |
| `<leader>rk` | Scroll reference panel up |