local args = { ... }

-- stylua: ignore
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

-- TODO: refactor this
local function rel_position(file)
	for i, f in ipairs(Folder:by_kind(Folder.CURRENT).window) do
		if f == file then
			return i
		end
	end
end

local function toggle_ui(state)
	ya.render()
	if state.icon or state.mode then
		Folder.icon, Status.mode, state.icon, state.mode = state.icon, state.mode, nil, nil
		return
	end

	state.icon, state.mode = Folder.icon, Status.mode
	Folder.icon = function(self, file)
		local pos = rel_position(file)
		if not pos then
			return state.icon(self, file)
		elseif state.num > 26 then
			return ui.Span(DOUBLE_KEYS[pos] .. " " .. file:icon().text .. " ")
		else
			return ui.Span(SINGLE_KEYS[pos] .. " " .. file:icon().text .. " ")
		end
	end
	Status.mode = function(self)
		local style = self.style()
		return ui.Line {
			ui.Span(THEME.status.separator_open):fg(style.bg),
			ui.Span(" KJ-" .. tostring(cx.active.mode):upper() .. " "):style(style),
		}
	end
end

local function next(sync, args) ya.manager_emit("plugin", { "keyjump", sync = sync, args = table.concat(args, " ") }) end

return {
	entry = function()
		local action = args[1]
		if not action then
			state.num = #Folder:by_kind(Folder.CURRENT).window
			toggle_ui(state)
			return next(false, { "prompt", state.num })
		end

		if action == "prompt" then
			local cands, num = nil, tonumber(args[2])
			if num > 26 then
				cands = { table.unpack(DOUBLE_CANDS, 1, num) }
			else
				cands = { table.unpack(SIGNAL_CANDS, 1, num) }
			end

			local key = ya.which { cands = cands, silent = true }
			return next(true, key and { "apply", key } or { "reset" })
		end

		toggle_ui(state)
		if action == "apply" then
			local pos = Folder:by_kind(Folder.CURRENT).cursor - Folder:by_kind(Folder.CURRENT).offset
			ya.manager_emit("arrow", { tostring(args[2] - pos - 1) })
		end
	end,
}
