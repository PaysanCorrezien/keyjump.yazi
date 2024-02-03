-- global
B_isJumpMode = false
B_isDoubleKey = false

T_signalKey = {'p','b','e', 't', 'a', 'o', 'i', 'n', 's', 'r', 'h',
'l', 'd', 'c', 'u', 'm', 'f', 'g', 'w', 'v', 'k', 'j',
'x','z', 'y','q'}

T_doubleKey = {
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

local function getFilePosition(file)
	for i, f in ipairs(Folder:by_kind(Folder.CURRENT).window) do
		if f == file then
			return i
		end
	end
    return 0
end

function Folder:icon(file)
	if B_isJumpMode then
		local position = getFilePosition(file)
		if position == 0 then
			return ui.Span(" " .. file:icon().text .. " ")
		elseif B_isDoubleKey then
			return ui.Span(T_doubleKey[position] .. " " .. file:icon().text .. " ")
		else
			return ui.Span(T_signalKey[position] .. " " .. file:icon().text .. " ")
		end
	else
		return ui.Span(" " .. file:icon().text .. " ")
	end
end

function Status:mode()
	local mode = "UNSET"
	if B_isJumpMode then
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