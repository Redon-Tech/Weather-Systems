local Plugin = script.Parent.Parent
local Packages = Plugin.Parent.Packages
local Roact = require(Packages.roact)
local StudioComponents = require(Packages.studiocomponents)

local Menu = Roact.Component:extend("Menu")
local SystemSettings = require(script.Parent.SystemSettings)

function Menu:setActive(active: boolean)
    self:setState({
        Active = active
    })
end

function Menu:init()
    self:setActive(true)
end

function Menu:render()
    return self.state.Active and Roact.createElement("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.5, 1),
        BackgroundTransparency = 1
    }, {
        UIListLayout = Roact.createElement("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5),
        }),
        MainLabel = Roact.createElement(StudioComponents.Label, {
            Size = UDim2.new(1, 0, 0, 50),
            Text = "SETUP WEATHER",
            TextSize = 25,
            LayoutOrder = 1,
        }),
        Install = Roact.createElement(StudioComponents.Button, {
            Size = UDim2.new(1, 0, 0, 50),
            Text = "Install",
            TextSize = 25,
            OnActivated = function()
                print("Install")
            end,
            LayoutOrder = 2,
        }),
        SysSettings = Roact.createElement(StudioComponents.Button, {
            Size = UDim2.new(1, 0, 0, 50),
            Text = "System Settings",
            TextSize = 25,
            OnActivated = function()
                print("System Settings")
            end,
            LayoutOrder = 3,
        }),
        ClimateSettings = Roact.createElement(StudioComponents.Button, {
            Size = UDim2.new(1, 0, 0, 50),
            Text = "Climate Settings",
            TextSize = 25,
            OnActivated = function()
                print("Climate Settings")
            end,
            LayoutOrder = 4,
        }),
        Gap = Roact.createElement("Frame", {
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundTransparency = 1,
            LayoutOrder = 5,
        }),
        Uninstall = Roact.createElement(StudioComponents.Button, {
            Size = UDim2.new(1, 0, 0, 50),
            Text = "Uninstall",
            TextSize = 25,
            OnActivated = function()
                print("Uninstall")
            end,
            LayoutOrder = 6,
        }),
    })
end

return Menu