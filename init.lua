local M = {}

local args = { ... }

local SINGLE_KEYS = {
	"p", "b", "e", "t", "a", "o", "i", "n", "s", "r", "h", "l", "d", "c",
	"u", "m", "f", "g", "w", "v", "k", "j", "x", "z", "y", "q"
}
-- stylua: ignore
local DOUBLE_KEYS = {
	"au", "ai", "ao", "ah", "aj", "ak", "al", "an", "su", "si", "so", "sh",
	"sj", "sk", "sl", "sn", "du", "di", "do", "dh", "dj", "dk", "dl", "dn",
	"fu", "fi", "fo", "fh", "fj", "fk", "fl", "fn", "gu", "gi", "go", "gh",
	"gj", "gk", "gl", "gn", "eu", "ei", "eo", "eh", "ej", "ek", "el", "en",
	"ru", "ri", "ro", "rh", "rj", "rk", "rl", "rn", "cu", "ci", "co", "ch",
	"cj", "ck", "cl", "cn", "wu", "wi", "wo", "wh", "wj", "wk", "wl", "wn"
}
-- stylua: ignore
local SIGNAL_CANDS = {
	{ on = "p" }, { on = "b" }, { on = "e" }, { on = "t" }, { on = "a" },
	{ on = "o" }, { on = "i" }, { on = "n" }, { on = "s" }, { on = "r" },
	{ on = "h" }, { on = "l" }, { on = "d" }, { on = "c" }, { on = "u" },
	{ on = "m" }, { on = "f" }, { on = "g" }, { on = "w" }, { on = "v" },
	{ on = "k" }, { on = "j" }, { on = "x" }, { on = "z" }, { on = "y" },
	{ on = "q" },
}
-- stylua: ignore
local DOUBLE_CANDS = {
	{ on = { "a", "u" } }, { on = { "a", "i" } }, { on = { "a", "o" } },
	{ on = { "a", "h" } }, { on = { "a", "j" } }, { on = { "a", "k" } },
	{ on = { "a", "l" } }, { on = { "a", "n" } }, { on = { "s", "u" } },
	{ on = { "s", "i" } }, { on = { "s", "o" } }, { on = { "s", "h" } },
	{ on = { "s", "j" } }, { on = { "s", "k" } }, { on = { "s", "l" } },
	{ on = { "s", "n" } }, { on = { "d", "u" } }, { on = { "d", "i" } },
	{ on = { "d", "o" } }, { on = { "d", "h" } }, { on = { "d", "j" } },
	{ on = { "d", "k" } }, { on = { "d", "l" } }, { on = { "d", "n" } },
	{ on = { "f", "u" } }, { on = { "f", "i" } }, { on = { "f", "o" } },
	{ on = { "f", "h" } }, { on = { "f", "j" } }, { on = { "f", "k" } },
	{ on = { "f", "l" } }, { on = { "f", "n" } }, { on = { "g", "u" } },
	{ on = { "g", "i" } }, { on = { "g", "o" } }, { on = { "g", "h" } },
	{ on = { "g", "j" } }, { on = { "g", "k" } }, { on = { "g", "l" } },
	{ on = { "g", "n" } }, { on = { "e", "u" } }, { on = { "e", "i" } },
	{ on = { "e", "o" } }, { on = { "e", "h" } }, { on = { "e", "j" } },
	{ on = { "e", "k" } }, { on = { "e", "l" } }, { on = { "e", "n" } },
	{ on = { "r", "u" } }, { on = { "r", "i" } }, { on = { "r", "o" } },
	{ on = { "r", "h" } }, { on = { "r", "j" } }, { on = { "r", "k" } },
	{ on = { "r", "l" } }, { on = { "r", "n" } }, { on = { "c", "u" } },
	{ on = { "c", "i" } }, { on = { "c", "o" } }, { on = { "c", "h" } },
	{ on = { "c", "j" } }, { on = { "c", "k" } }, { on = { "c", "l" } },
	{ on = { "c", "n" } }, { on = { "w", "u" } }, { on = { "w", "i" } },
	{ on = { "w", "o" } }, { on = { "w", "h" } }, { on = { "w", "j" } },
	{ on = { "w", "k" } }, { on = { "w", "l" } }, { on = { "w", "n" } },
}


if args[1] == "sync-init" then
	IsInJumpMode = false
	UseDoubleKey = false
	IsInWinOS = false
	KeyJumpType = ""
	ItemNumInCurrentWindow = 0
end

-- util function
local function getFilePosition(file)
	for i, f in ipairs(Folder:by_kind(Folder.CURRENT).window) do
		if f == file then
			return i
		end
	end
    return 0
end

local function getCurrenAreaItemNum()
	return #(Folder:by_kind(Folder.CURRENT).window)
end

local function getCursorPosition()
    return Folder:by_kind(Folder.CURRENT).cursor - Folder:by_kind(Folder.CURRENT).offset
end

local function isWinOS()
	local home_path = os.getenv("HOME")
	if home_path == nil then
		return true
	end
	
	local result = string.match(home_path,":")
	if result ~= nil then
		return true
	end

	return false
end

local function setKeyMode()
	ItemNumInCurrentWindow = getCurrenAreaItemNum()
	if ItemNumInCurrentWindow > 26 then
		UseDoubleKey = true
	else
		UseDoubleKey = false
	end
end


local function getFileFromPosition(pos)
	return (Folder:by_kind(Folder.CURRENT).window)[pos]
end

local function getFileNumFromPath(path)
	local cmd = "ls "
	if IsInWinOS then
		cmd = "dir "
	end

    local a = io.popen(cmd..path);
    local f = {};
    for l in a:lines() do
        table.insert(f,l)
    end
    a:close()
    return #f
end

-- overwirte system function
if Folder then
	function Folder:icon(file)
		if IsInJumpMode then
			local position = getFilePosition(file)
			if position == 0 then
				return ui.Span(" " .. file:icon().text .. " ")
			elseif UseDoubleKey then
				return ui.Span(" " .. file:icon().text .. " "..DOUBLE_KEYS[position].. " ")
			else
				return ui.Span(" " .. file:icon().text .. " "..SINGLE_KEYS[position].. " ")
			end
		else
			return ui.Span(" " .. file:icon().text .. " ")
		end
	end
end

if Status then
	function Status:mode()
		local mode = "UNSET"
		if IsInJumpMode and KeyJumpType == "normal" then
			mode = "KJN-" .. tostring(cx.active.mode):upper()
		elseif IsInJumpMode and KeyJumpType == "keep" then
				mode = "KJK-" .. tostring(cx.active.mode):upper()
		else
			mode = tostring(cx.active.mode):upper() -- accessing the current context through cx
		end

		if mode == "UNSET" then
			mode = "UN-SET"
		end

		local style = self.style()
		return ui.Line {
			ui.Span(THEME.status.separator_open):fg(style.bg),
			ui.Span(" " .. mode .. " "):style(style),
		}
	end
end

local function init()
	IsInJumpMode = true
	KeyJumpType = args[2]
	setKeyMode()
	IsInWinOS =	isWinOS()
	ya.render()
	ya.manager_emit("plugin", { "keyjump", args = tostring("async-getinput").." "..tostring(UseDoubleKey).." "..tostring(ItemNumInCurrentWindow) })
end

local function getinput()
	local target_candy
	if args[2] == "false" then
		target_candy = {table.unpack(SIGNAL_CANDS, 1, args[3])}
	else
		target_candy = {table.unpack(DOUBLE_CANDS, 1, args[3])}
	end
	local key = ya.which {
		cands = target_candy,
		silent = true, 
	}
	if key ~= nil then
		ya.manager_emit("plugin", { "keyjump", sync = "", args = tostring(key - 1) })
	else
		ya.manager_emit("plugin", { "keyjump", sync = "", args = tostring("sync-nilkey") })
	end		
end

local function normalAction()
	local cursor_position = getCursorPosition()
	IsInJumpMode = false
	ya.render()
	ya.manager_emit("arrow", {tostring(tonumber(args[1]) - cursor_position ) })	
end

local function keepAction()
	local cursor_position = getCursorPosition()
	ya.manager_emit("arrow", {tostring(tonumber(args[1]) - cursor_position ) })	
	local target_file = getFileFromPosition(tonumber(args[1])+1)
	if target_file and target_file.cha.is_dir then
		ya.manager_emit("enter",{})	 -- TODO: need to block

		local ItemNumInCurrentWindow = getFileNumFromPath(tostring(target_file.url))
		if ItemNumInCurrentWindow == 0 then
			IsInJumpMode = false
			ya.render()	
			return		
		end

		if ItemNumInCurrentWindow > 26 then
			UseDoubleKey = true
		else
			UseDoubleKey = false
		end

		ya.manager_emit("plugin", { "keyjump", args = tostring("async-getinput").." "..tostring(UseDoubleKey).." "..tostring(ItemNumInCurrentWindow) })
	else
		IsInJumpMode = false
		ya.render()		
	end
end

local function nilkeyAction()
	IsInJumpMode = false
	ya.render()			
end

function M:entry()
	if args[1] == "sync-init" then --sync context
		init()
	elseif args[1] == "async-getinput" then --async context
		getinput()
	elseif args[1] == "sync-nilkey" then --sync context
		nilkeyAction()
	else --sync context
		if KeyJumpType == "normal" then
			normalAction()
		elseif KeyJumpType == "keep" then
			keepAction()
		else
			ya.err("unknow action")
		end
	end
end

return M
