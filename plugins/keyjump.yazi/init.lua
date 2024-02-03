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
    -- {on = {"t","u"}}, {on = {"t","i"}}, {on={"t","o"}}, {on={"t","h"}}, {on={"t","j"}}, {on={"t","k"}}, {on={"t","l"}}, {on={"t","n"}},
    -- {on = {"v","u"}}, {on = {"v","i"}}, {on={"v","o"}}, {on={"v","h"}}, {on={"v","j"}}, {on={"v","k"}}, {on={"v","l"}}, {on={"v","n"}},
    -- {on = {"x","u"}}, {on = {"x","i"}}, {on={"x","o"}}, {on={"x","h"}}, {on={"x","j"}}, {on={"x","k"}}, {on={"x","l"}}, {on={"x","n"}},
    -- {on = {"z","u"}}, {on = {"z","i"}}, {on={"z","o"}}, {on={"z","h"}}, {on={"z","j"}}, {on={"z","k"}}, {on={"z","l"}}, {on={"z","n"}},
    -- {on = {"b","u"}}, {on = {"b","i"}}, {on={"b","o"}}, {on={"b","h"}}, {on={"b","j"}}, {on={"b","k"}}, {on={"b","l"}}, {on={"b","n"}},
    -- {on = {"q","u"}}, {on = {"q","i"}}, {on={"q","o"}}, {on={"q","h"}}, {on={"q","j"}}, {on={"q","k"}}, {on={"q","l"}}, {on={"q","n"}},
	-- {on = {"a","p"}}, {on = {"a","y"}}, {on={"a","m"}},
	-- {on = {"f","p"}}, {on = {"f","y"}}, {on={"f","m"}},
	-- {on = {"e","p"}}, {on = {"e","y"}}, {on={"e","m"}},
	-- {on = {"s","p"}}, {on = {"s","y"}}, {on={"s","m"}},
	-- {on = {"d","p"}}, {on = {"d","y"}}, {on={"d","m"}},
	-- {on = {"g","p"}}, {on = {"g","y"}}, {on={"g","m"}},
	-- {on = {"r","p"}}, {on = {"r","y"}}, {on={"r","m"}},
	-- {on = {"c","p"}}, {on = {"c","y"}}, {on={"c","m"}},
	-- {on = {"w","p"}}, {on = {"w","y"}}, {on={"w","m"}},
	-- {on = {"x","p"}}, {on = {"x","y"}}, {on={"x","m"}},
	-- {on = {"t","p"}}, {on = {"t","y"}}, {on={"t","m"}},
	-- {on = {"v","p"}}, {on = {"v","y"}}, {on={"v","m"}},
	-- {on = {"b","p"}}, {on = {"b","y"}}, {on={"b","m"}},
	-- {on = {"z","p"}}, {on = {"z","y"}}, {on={"z","m"}},
	-- {on = {"q","p"}}, {on = {"q","y"}}, {on={"q","m"}},
}


local M = {}

local function getCurrenAreaItemNum()
	return #(Folder:by_kind(Folder.CURRENT).window)
end

local function getCursorPosition()
    return Folder:by_kind(Folder.CURRENT).cursor - Folder:by_kind(Folder.CURRENT).offset
end

local function setKeyMode()
	local i_item_num = getCurrenAreaItemNum()
	if i_item_num > 26 then
		B_isDoubleKey = true
	else
		B_isDoubleKey = false
	end
end

function M:entry()

	if args[1] ~= nil then
		if args[1] == "init" then
    		B_isJumpMode = true
    		setKeyMode()
			ya.render()
			ya.manager_emit("plugin", { "keyjump", args = tostring("getinput").." "..tostring(B_isDoubleKey) })
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
			B_isJumpMode = false
			ya.render()
			ya.manager_emit("arrow", { "-"..tostring(cursor_position) })
			ya.manager_emit("arrow", { args[1] })
		end
	else
		ya.manager_emit("plugin", { "keyjump", sync = "", args = tostring("init") })
	end
end

return M

