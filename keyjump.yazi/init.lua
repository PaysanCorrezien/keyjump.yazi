local M = {}

local args = { ... }

local t_signalKey_candy = {
{on={'p'}}, {on={'b'}},
{on={'e'}}, {on={'t'}},
{on={'a'}}, {on={'o'}},
{on={'i'}}, {on={'n'}},
{on={'s'}}, {on={'r'}},
{on={'h'}}, {on={'l'}},
{on={'d'}}, {on={'c'}},
{on={'u'}}, {on={'m'}},
{on={'f'}}, {on={'g'}},
{on={'w'}}, {on={'v'}},
{on={'k'}}, {on={'j'}},
{on={'x'}}, {on={'z'}},
{on={'y'}}, {on={'q'}}
}

local t_doubleKey_candy = {
    {on = {"a","u"}}, {on = {"a","i"}}, {on={"a","o"}}, {on={"a","h"}}, {on={"a","j"}}, {on={"a","k"}}, {on={"a","l"}}, {on={"a","n"}},
    {on = {"s","u"}}, {on = {"s","i"}}, {on={"s","o"}}, {on={"s","h"}}, {on={"s","j"}}, {on={"s","k"}}, {on={"s","l"}}, {on={"s","n"}},
    {on = {"d","u"}}, {on = {"d","i"}}, {on={"d","o"}}, {on={"d","h"}}, {on={"d","j"}}, {on={"d","k"}}, {on={"d","l"}}, {on={"d","n"}},
    {on = {"f","u"}}, {on = {"f","i"}}, {on={"f","o"}}, {on={"f","h"}}, {on={"f","j"}}, {on={"f","k"}}, {on={"f","l"}}, {on={"f","n"}},
	{on = {"g","u"}}, {on = {"g","i"}}, {on={"g","o"}}, {on={"g","h"}}, {on={"g","j"}}, {on={"g","k"}}, {on={"g","l"}}, {on={"g","n"}},
    {on = {"e","u"}}, {on = {"e","i"}}, {on={"e","o"}}, {on={"e","h"}}, {on={"e","j"}}, {on={"e","k"}}, {on={"e","l"}}, {on={"e","n"}},
    {on = {"r","u"}}, {on = {"r","i"}}, {on={"r","o"}}, {on={"r","h"}}, {on={"r","j"}}, {on={"r","k"}}, {on={"r","l"}}, {on={"r","n"}},
    {on = {"c","u"}}, {on = {"c","i"}}, {on={"c","o"}}, {on={"c","h"}}, {on={"c","j"}}, {on={"c","k"}}, {on={"c","l"}}, {on={"c","n"}},
    {on = {"w","u"}}, {on = {"w","i"}}, {on={"w","o"}}, {on={"w","h"}}, {on={"w","j"}}, {on={"w","k"}}, {on={"w","l"}}, {on={"w","n"}},
}

local t_signalKey = {'p','b','e', 't', 'a', 'o', 'i', 'n', 's', 'r', 'h',
'l', 'd', 'c', 'u', 'm', 'f', 'g', 'w', 'v', 'k', 'j',
'x','z', 'y','q'}

local t_doubleKey = {
    "au", "ai", "ao", "ah", "aj", "ak", "al", "an",
    "su", "si", "so", "sh", "sj", "sk", "sl", "sn",
    "du", "di", "do", "dh", "dj", "dk", "dl", "dn",
    "fu", "fi", "fo", "fh", "fj", "fk", "fl", "fn",
	"gu", "gi", "go", "gh", "gj", "gk", "gl", "gn",
    "eu", "ei", "eo", "eh", "ej", "ek", "el", "en",
    "ru", "ri", "ro", "rh", "rj", "rk", "rl", "rn",
    "cu", "ci", "co", "ch", "cj", "ck", "cl", "cn",
    "wu", "wi", "wo", "wh", "wj", "wk", "wl", "wn",
}

local b_isJumpMode = false
local b_isDoubleKey = false

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

local function setKeyMode()
	local i_item_num = getCurrenAreaItemNum()
	if i_item_num > 26 then
		b_isDoubleKey = true
	else
		b_isDoubleKey = false
	end
end

-- overwirte system function
if Folder then
	function Folder:icon(file)
		if b_isJumpMode then
			local position = getFilePosition(file)
			if position == 0 then
				return ui.Span(" " .. file:icon().text .. " ")
			elseif b_isDoubleKey then
				return ui.Span(" " .. file:icon().text .. " "..t_doubleKey[position].. " ")
			else
				return ui.Span(" " .. file:icon().text .. " "..t_signalKey[position].. " ")
			end
		else
			return ui.Span(" " .. file:icon().text .. " ")
		end
	end
end

if Status then
	function Status:mode()
		local mode = "UNSET"
		if b_isJumpMode then
			mode = "KJ-" .. tostring(cx.active.mode):upper()
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

function M:entry()

	if args[1] ~= nil then
		if args[1] == "init" then
    		b_isJumpMode = true
    		setKeyMode()
			ya.render()
			ya.manager_emit("plugin", { "keyjump", args = tostring("getinput").." "..tostring(b_isDoubleKey) })
		elseif args[1] == "getinput" then
			local target_candy
			if args[2] == "false" then
				target_candy = t_signalKey_candy
			else
				target_candy = t_doubleKey_candy
			end
			local key = ya.which {
				cands = target_candy,
				silent = true, 
			}
			if key ~= nil then
				ya.manager_emit("plugin", { "keyjump", sync = "", args = tostring(key) })
			end			
		else
			local cursor_position = getCursorPosition()
			b_isJumpMode = false
			ya.render()
			ya.manager_emit("arrow", { "-"..tostring(cursor_position) })
			ya.manager_emit("arrow", { args[1] })
		end
	else
		ya.manager_emit("plugin", { "keyjump", sync = "", args = tostring("init") })
	end
end

return M

