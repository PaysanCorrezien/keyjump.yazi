# keyjump
a yazi plugin which like flash.nvim in neovim,allow use key char to Precise selection




https://github.com/DreamMaoMao/keyjump/assets/30348075/6ba722ce-8b55-4c80-ac81-b6b7ade74491





# install
```
git clone https://github.com/DreamMaoMao/keyjump.git
cd keyjump
cp keyjump.yazi -r ~/.config/yazi/plugins
```

# usage
set shortcut key to toggle keyjump mode in ~/.config/yazi/keymap.toml.
for example set `i` to toggle keyjump mode

```toml
[manager]

keymap = [

	{ on = [ "i"], exec = "plugin keyjump --sync --args='sync-init'", desc = "keyjump" },]
```

when you see some character(singal character or double character) in left of the entry.
Press the key of the character will jump to the corresponding entry 
