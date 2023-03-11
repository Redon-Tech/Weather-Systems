local Plugin = script.Parent.Parent
local Packages = Plugin.Parent.Packages
local Roact = require(Packages.roact)
local StudioComponents = require(Packages.studiocomponents)

local Widget = StudioComponents.Widget
local Main = Roact.Component:extend("Main")
local Menu = require(script.Parent.Menu)
local SystemSettings = require(script.Parent.SystemSettings)

function Main:setActive(active: boolean)
    self:setState({
        Active = active
    })
    self.props.Button:SetActive(active)
end

function Main:init()
    self:setActive(false)
end

function Main:didMount()
    self.event = self.props.Button.Click:Connect(function()
        self:setActive(not self.state.Active)
    end)
end

function Main:willUnmount()
    self.event:Disconnect()
end

function Main:render()
    return Roact.createElement(Widget, {
        Id = self.props.PluginInformation.Widget_Name,
        Name = self.props.PluginInformation.Widget_Name,
        Title = self.props.PluginInformation.Name,
        InitialDockState = Enum.InitialDockState.Float,
        MinimumWindowSize = Vector2.new(250, 350),
        Enabled = if self.state.Active then true else false,
        OnClosed = function()
            self:setActive(false)
        end
    }, {
        Menu = Roact.createElement(Menu, {
            plugin = self.props.plugin,
            PluginInformation = self.props.PluginInformation
        }),
        SystemSettings = Roact.createElement(SystemSettings, {
            plugin = self.props.plugin,
            PluginInformation = self.props.PluginInformation
        })
    })
end

return Main