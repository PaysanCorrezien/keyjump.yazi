# keyjump
a yazi plugin which like flash.nvim in neovim,allow use key char to Precise selection



https://github.com/DreamMaoMao/keyjump/assets/30348075/bef60fdf-fe29-4706-9cd0-9cc2949e4455



# install
```
git clone https://github.com/DreamMaoMao/keyjump.git
cd keyjump
cp ./*  -r ~/.config/yazi/
```

# usage
set shortcut key to toggle keyjump mode in ~/.config/yazi/keymap.toml.
for example set `i` to toggle keyjump mode

```toml
[manager]

keymap = [

	{ on = [ "i"], exec = "plugin keyjump", desc = "toggle lable jump" },
]
```

when you see some character(singal character or double character) in left of the entry.
Press the key of the character will jump to the corresponding entry 