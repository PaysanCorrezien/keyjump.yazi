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
    -- "tu", "ti", "to", "th", "tj", "tk", "tl", "tn",
    -- "vu", "vi", "vo", "vh", "vj", "vk", "vl", "vn",
    -- "xu", "xi", "xo", "xh", "xj", "xk", "xl", "xn",
    -- "zu", "zi", "zo", "zh", "zj", "zk", "zl", "zn",
    -- "bu", "bi", "bo", "bh", "bj", "bk", "bl", "bn",
    -- "qu", "qi", "qo", "qh", "qj", "qk", "ql", "qn",
	-- "ap","ay", "am",
	-- "fp","fy", "fm",
	-- "ep","ey", "em",
	-- "sp","sy", "sm",
	-- "dp","dy", "dm",
	-- "gp","gy", "gm",
	-- "rp","ry", "rm",
	-- "cp","cy", "cm",
	-- "wp","wy", "wm",
	-- "xp","xy", "xm",
	-- "tp","ty", "tm",
	-- "vp","vy", "vm",
	-- "bp","by", "bm",
	-- "zp","zy", "zm",
	-- "qp","qy", "qm",
}




-- local function getCurrenAreaItemNum()
-- 	return #(Folder:by_kind(Folder.CURRENT).window)
-- end

-- local function setKeyMode()
-- 	local num = getCurrenAreaItemNum()
-- 	if num > 26 then
-- 		B_isDoubleKey = true
-- 	else
-- 		B_isDoubleKey = false
-- 	end
-- end

-- local function getItemIcon(pos)
-- 	local t_item_area = Folder:by_kind(Folder.CURRENT).window
-- 	local t_target_file = t_item_area[pos]
-- 	local s_icon = t_target_file:icon()
-- 	return s_icon
-- end

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

-- function Manager:render(area)
-- 	if B_isJumpMode then
-- 		setKeyMode() -- calculate item num of current area to decide the key mode
-- 	end
	
-- 	self.area = area
-- 	local chunks = ui.Layout()
-- 		:direction(ui.Layout.HORIZONTAL)
-- 		:constraints({
-- 			ui.Constraint.Ratio(MANAGER.ratio.parent, MANAGER.ratio.all),
-- 			ui.Constraint.Ratio(MANAGER.ratio.current, MANAGER.ratio.all),
-- 			ui.Constraint.Ratio(MANAGER.ratio.preview, MANAGER.ratio.all),
-- 		})
-- 		:split(area)

-- 	return ya.flat {
-- 		-- Borders
-- 		ui.Bar(chunks[1], ui.Bar.RIGHT):symbol(THEME.manager.border_symbol):style(THEME.manager.border_style),
-- 		ui.Bar(chunks[3], ui.Bar.LEFT):symbol(THEME.manager.border_symbol):style(THEME.manager.border_style),

-- 		-- Parent
-- 		Parent:render(chunks[1]:padding(ui.Padding.x(1))),
-- 		-- Current
-- 		Current:render(chunks[2]),
-- 		-- Preview
-- 		Preview:render(chunks[3]:padding(ui.Padding.x(1))),
-- 	}
-- end