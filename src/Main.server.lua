--[[
Redon Tech 2022
WS V2
--]]

--------------------------------------------------------------------------------
-- Init --
--------------------------------------------------------------------------------

local Is_RBXM = plugin.Name:find(".rbxm") ~= nil
local Selection = game:GetService("Selection")

local function getName(name: string)
	if Is_RBXM then
		name ..= " (RBXM)"
	end
	return name
end

local Plugin_Name = getName("Weather Syste,")
local Plugin_Description = "Easily add dynamic weather to your game!"
local Plugin_Icon = "rbxassetid://234354676654"
local Widget_Name = getName("Weather System")
local Button_Name = getName("Weather Sys Menu")


if _G.RTPlugins and typeof(_G.RTPlugins) == "table" then
	if _G.RTPlugins.Buttons[Plugin_Name] then
		Button = _G.RTPlugins.Buttons[Plugin_Name]
	else
		_G.RTPlugins.Buttons[Plugin_Name] = _G.RTPlugins.ToolBar:CreateButton(Button_Name, Plugin_Description, Plugin_Icon)
		Button = _G.RTPlugins.Buttons[Plugin_Name]
	end
else
	_G.RTPlugins = {
		ToolBar = plugin:CreateToolbar("Redon Tech Plugins"),
		Buttons = {}
	}

	_G.RTPlugins.Buttons[Plugin_Name] = _G.RTPlugins.ToolBar:CreateButton(Button_Name, Plugin_Description, Plugin_Icon)
	Button = _G.RTPlugins.Buttons[Plugin_Name]
end

--------------------------------------------------------------------------------
-- UI Setup --
--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
-- Plugin Functions --
--------------------------------------------------------------------------------