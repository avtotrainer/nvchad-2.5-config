# Windows

დაყენება: იხ. [README.md](README.md) — ერთი ბრძანება `install.ps1`-ით.

ყველა Windows-ის ცვლილება `has("win32")`-ის პირობით ან cross-platform `stdpath()`-ითაა — იგივე ფაილები Linux/NixOS-ზე უცვლელად მუშაობს.

## რა რა სჭირდება და რატომ

| ხელსაწყო | რისთვის |
|---|---|
| MinGW gcc (WinLibs) | treesitter parser-ების კომპილაცია. tree-sitter ნაგულისხმევად `cl.exe`-ს (Visual Studio) ეძებს; კონფიგი Windows-ზე `CC=gcc`-ს აყენებს. zig **არ** მუშაობს (msvc target-ს ვერ კითხულობს) |
| `tree-sitter-cli` (npm) | nvim-treesitter `main` branch-ს parser-ების ასაწყობად სჭირდება |
| Node.js | tree-sitter CLI, pyright, ts_ls, html/css LSP, prettier, eslint_d |
| Python | black, `py_compile` შემოწმება ფორმატირებამდე |
| Go (არასავალდებულო) | gopls; Go-ს გარეშე `:MasonInstallAll` gopls-ს გამოტოვებს |

## ფაილები

| ფაილი | რა აკეთებს |
|---|---|
| `install.ps1` | ერთი ბრძანებით დაყენება/განახლება |
| `bootstrap.lua` | `install.ps1`-ის headless ნაწილი: parser-ები + Mason პაკეტები |
| `update_chad.ps1` | `update_chad.sh` / `make update`-ის ანალოგი |
| `remove_nvim_config.ps1` | `remove_nvim_config`-ის ანალოგი (`-Backup`, `-DeleteBackup`) |
| `lua/options.lua` | Linux-ზე wl-clipboard; Windows-ზე shell = pwsh/powershell |
| `lua/chadrc.lua` | Windows-ზე `M.mason.pkgs` — `:MasonInstallAll` LSP-ებს სხვაგვარად მხოლოდ ფაილის გახსნის შემდეგ ხედავს |
| `lua/plugins/init.lua` | nvim-treesitter `main`: parser-ების დაყენება, highlight/indent `FileType`-ზე |
| `lua/plugins/copilot.lua` | Copilot; NixOS-ზე PATH-ის `copilot-language-server` ან nodejs რეჟიმი |
| `lua/utils/telescope_menu.lua` | ლოგები `stdpath()`-ით, გასუფთავება `vim.fn.delete()`-ით |

## გზები

| | Linux | Windows |
|---|---|---|
| config | `~/.config/nvim` | `%LOCALAPPDATA%\nvim` |
| data (lazy, mason, parser-ები) | `~/.local/share/nvim` | `%LOCALAPPDATA%\nvim-data` |
| state | `~/.local/state/nvim` | `%LOCALAPPDATA%\nvim-data` |
| cache | `~/.cache/nvim` | `%TEMP%\nvim` |

## ხშირი პრობლემები

- **`nvim` ვერ მოიძებნა** — დაყენების შემდეგ ახალი ტერმინალი გახსენი.
- **ფაილს ვერ ინახავ** — nvim Start მენიუდან `C:\Program Files\Neovim\bin`-ში იხსნება; გახსენი ტერმინალიდან სამუშაო საქაღალდეში.
- **Copilot `NotSignedIn`** — github.com/settings/copilot-ზე ჩართე Copilot Free, შემდეგ `:Copilot auth signout` → `:Copilot auth signin` → nvim-ის გადატვირთვა.
