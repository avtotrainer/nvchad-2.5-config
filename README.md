# NvChad 2.5 ᲙᲝᲜᲤᲘᲒᲣᲠᲐᲪᲘᲐ

ეს კონფიგი დაფუძნებულია [ამ რეპოზიტორიზე](https://github.com/AlariCode/nvchad-2.5-config), რომელშიც კარგად არის გაკეთებული ყველაფერი ვებ დიველოპერისათვის, მხარდაჭერილი ენები და ხელსაწყოები lua,html,css,typescript,javascript,go,python, markdown. ბოლო ორი დავამატე მე.

## ᲘᲜᲡᲢᲐᲚᲐᲪᲘᲐ

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
