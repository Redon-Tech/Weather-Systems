local Plugin = script.Parent.Parent
local Packages = Plugin.Parent.Packages
local Roact = require(Packages.roact)
local StudioComponents = require(Packages.studiocomponents)

local SystemSettings = Roact.Component:extend("SystemSettings")

function SystemSettings:setActive(active: boolean)
    self:setState({
        Active = active
    })
end

function SystemSettings:init()
    self:setActive(false)
end

function SystemSettings:render()
    return self.state.Active and Roact.createElement("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.5, 1),
        BackgroundTransparency = 1,
    }, {
        Label = Roact.createElement(StudioComponents.Label, {
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0),
            Size = UDim2.new(1, 0, 0, 50),
            Text = "System Settings",
            TextSize = 25
        }),
        Settings = Roact.createElement("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 0.9),
        }, {
            UIListLayout = Roact.createElement("UIListLayout", {
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 5),
            }),
        }),
        AdminSettings = Roact.createElement(StudioComponents.Button, {
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 1),
            Size = UDim2.new(0, 100, 0, 50),
            Text = "Admin Settings",
            TextSize = 25,
            OnActivated = function()
                print("Admin Settings")
            end,
            LayoutOrder = 1,
        }),
    })
end

return SystemSettings