# keyjump.yazi

a yazi plugin which like flash.nvim in neovim,allow use key char to Precise selection

### keep mode


https://github.com/DreamMaoMao/keyjump.yazi/assets/30348075/dd998a34-49b0-481d-b032-d9849a89ba48




### once mode
https://github.com/DreamMaoMao/keyjump/assets/30348075/6ba722ce-8b55-4c80-ac81-b6b7ade74491

# install

## Linux

```bash
git clone https://github.com/DreamMaoMao/keyjump.yazi.git ~/.config/yazi/plugins/keyjump.yazi
```

## Windows

With `Powershell` :

```powershell
if (!(Test-Path $env:APPDATA\yazi\config\plugins\)) {mkdir $env:APPDATA\yazi\config\plugins\}
git clone https://github.com/DreamMaoMao/keyjump.yazi.git $env:APPDATA\yazi\config\plugins\keyjump.yazi
```

# Usage

set shortcut key to toggle keyjump mode in ~/.config/yazi/keymap.toml.
for example set `i` to toggle keyjump mode

```toml
[manager]

keymap = [

	# keep mode, when select a dir, it will auto enter and keep in keyjump mode.
	# when select a file or press <ESC> or select no match, it will leave keyjump mode.
	{ on = [ "i"], exec = "plugin keyjump --sync --args='keep'", desc = "keyjump" },

	# normal mode, when select a item, it will auto leave keyjump mode
	{ on = [ "z"], exec = "plugin keyjump --sync --args=''", desc = "keyjump" },
] 
```

when you see some character(singal character or double character) in left of the entry.
Press the key of the character will jump to the corresponding entry
