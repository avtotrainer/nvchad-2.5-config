# NvChad 2.5 ᲙᲝᲜᲤᲘᲒᲣᲠᲐᲪᲘᲐ

ეს კონფიგი დაფუძნებულია [ამ რეპოზიტორიზე](https://github.com/AlariCode/nvchad-2.5-config), რომელშიც კარგად არის გაკეთებული ყველაფერი ვებ დიველოპერისათვის, მხარდაჭერილი ენები და ხელსაწყოები lua,html,css,typescript,javascript,go,python, markdown. ბოლო ორი დავამატე მე.

არსებულ კონფიგურაციაში მე გავთიშე აუტოკომპლიტის ავტომატური გამოსვლა, მისი გამოძახება შესაძლებელია `Ctrl + Space ` კომბინაციით. 

## GitHub Copilot

AI ავტოდასრულებისთვის გამოიყენება [copilot.lua](https://github.com/zbirenbaum/copilot.lua) (`lua/plugins/copilot.lua`). საკმარისია უფასო [Copilot Free](https://github.com/features/copilot/plans) (2000 შევსება თვეში). პირველ გაშვებაზე: `:Copilot auth`.

შეთავაზება ავტომატურად არ ჩნდება (Copilot Free-ის ქვოტაში ყველა ნაჩვენები შეთავაზება ითვლება) — გამოიძახე `Alt + ]`-ით.

| კლავიში (insert) | მოქმედება |
|---|---|
| `Alt + ]` | შეთავაზების გამოძახება / შემდეგი შეთავაზება |
| `Alt + [` | წინა შეთავაზება |
| `Ctrl + g` | შეთავაზების მიღება |
| `Alt + w` / `Alt + l` | მხოლოდ სიტყვის / ხაზის მიღება |
| `Ctrl + ]` | უარყოფა |
| `Alt + a` | ავტომატური შეთავაზებების ჩართვა/გამორთვა (მიმდინარე სესიაში) |

NixOS-ზე ჩამოტვირთული binary არ ეშვება, ამიტომ დააყენე `pkgs.copilot-language-server` (კონფიგი თავად იპოვის PATH-ში) ან Node.js 22+ (nodejs რეჟიმი).


## ᲘᲜᲡᲢᲐᲚᲐᲪᲘᲐ — WINDOWS

ერთი ბრძანება ჩვეულებრივ (არა-admin) PowerShell-ში — სუფთა Windows-ზეც:

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/avtotrainer/nvchad-2.5-config/main/install.ps1)))
```

`install.ps1` winget-ით აყენებს Neovim-ს, Git-ს, ripgrep-ს, fd-ს, MinGW gcc-ს, Node.js-ს, Python-ს და JetBrainsMono Nerd Font-ს, npm-ით `tree-sitter-cli`-ს, კლონავს კონფიგს `%LOCALAPPDATA%\nvim`-ში და headless რეჟიმში აყენებს plugin-ებს (`lazy-lock.json`-ის ვერსიებით), treesitter parser-ებს და Mason-ის LSP-ებს.
პარამეტრები: `-WithGo` (Go + gopls), `-NoFont`, `-SkipTools` (მხოლოდ კონფიგი და plugin-ები).

ხელით დარჩება: ახალი ტერმინალის გახსნა, Windows Terminal-ში ფონტის არჩევა (Settings → Profile → Appearance → Font face) და nvim-ში `:Copilot auth signin`.

**განახლება:** იგივე ბრძანება ხელახლა — თუ კონფიგი უკვე ამ რეპოზიტორიის clone-ია, `git pull`-ს გააკეთებს. ან nvim-ში `<leader>mu` მენიუ / `update_chad.ps1`.

Windows-ის დეტალები და რა განსხვავდება Linux-ისგან: [WINDOWS.md](WINDOWS.md).

## ᲘᲜᲡᲢᲐᲚᲐᲪᲘᲐ — LINUX

### nvim-ის კონფიგის გასუფთავება

```bash
rm -rf ~/.cache/nvim
```

```bash
rm -rf ~/.local/share/nvim
```

```bash
rm -rf ~/.local/state/nvim
```

```bash
rm -rf ~/.config/nvim
```
რეპოზიტორიდან შეგიძლიათ ჩამოიწეროთ თქვენი nvim-ის კონფიგის გასუფთავების სკრიპტი remove_nvim_config, რომელიც `-b` პარამეტრის მითითებით ძველ კონფიგურაციას შეინახავს, ხოლო ზემო ამ პროცედურებს გააკეთებს ერთ ბძანებაში.

### ᲓᲐᲧᲔᲜᲔᲑᲐ

```bash
git clone https://github.com/avtotrainer/nvchad-2.5-config.git ~/.config/nvim --depth 1 && nvim
```
### ᲓᲐᲧᲔᲜᲔᲑᲘᲡ ᲛᲔᲠᲔ

```lua
:MasonInstallAll
```

```lua
:Lazy sync
```
