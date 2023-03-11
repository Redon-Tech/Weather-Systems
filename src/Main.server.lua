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

local Plugin_Name = getName("Weather System")
local Plugin_Description = "Easily add dynamic weather to your game!"
local Plugin_Icon = "http://www.roblox.com/asset/?id=319050289"
local Widget_Name = getName("WeatherSys")
local Button_Name = getName("Weather Sys Menu")
local Packages = script.Parent.Parent.Packages


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

-- local Config = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 1280, 720)
-- -- TODO: Change this default size to reflect the default menu
-- local GUI = plugin:CreateDockWidgetPluginGui(Widget_Name, Config)
-- GUI.Title = Plugin_Name
-- GUI.Name = Widget_Name
local Roact = require(Packages.roact)
local Main = require(script.Parent.UI.Main)
local MainElement = Roact.createElement(Main, {
	plugin = plugin,
	PluginInformation = {
		Name = Plugin_Name,
		Description = Plugin_Description,
		Icon = Plugin_Icon,
		Widget_Name = Widget_Name,
		Button_Name = Button_Name
	},
	Button = Button,
})
local GUI = Roact.mount(MainElement, nil, Widget_Name)

--------------------------------------------------------------------------------
-- Plugin Functions --
--------------------------------------------------------------------------------

plugin.Unloading:Connect(function()
	Roact.unmount(GUI)
end)