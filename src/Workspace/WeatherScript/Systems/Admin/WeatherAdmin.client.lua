local allowed = game.ReplicatedStorage.WeatherFunction:InvokeServer()
if allowed == false then
	script.Parent:Destroy()
end

local Weather = {
	"Auto",
	"Sunny",
	"Partly Cloudy",
	"Mostly Cloudy",
	"Cloudy",
	"Drizzle",
	"Freezing Drizzle",
	"Flurries",
	"Showers",
	"Rain / Snow Showers",
	"Snow Showers",
	"Rain",
	"Rain / Snow",
	"Snow",
	"Heavy Rain",
	"Heavy Rain / Snow",
	"Heavy Snow",
	"Thunderstorms",
	"Strong Thunderstorms"	
}


local RbxGui = require(game:GetService("ReplicatedStorage"):WaitForChild("LoadLibrary"):WaitForChild("RbxGui"))

local GUI = script.Parent.Frame
local SelectedWeather = "Sunny"

local WeatherDropDown, updateWeatherSelection = RbxGui.CreateDropDownMenu(Weather, function(value) SelectedWeather = value end)
WeatherDropDown.Name = "WeatherDropDownLower"
WeatherDropDown.Position = UDim2.new(0, 20, 0, 60)
WeatherDropDown.Size = UDim2.new(0, 240, 0, 40)
WeatherDropDown.Parent = GUI
WeatherDropDown.Visible = true

GUI.SetWeather.MouseButton1Click:connect(function()
	game.ReplicatedStorage.WeatherResources.Settings.AdminEvent:FireServer("Weather", SelectedWeather)
end)

GUI.SetTime.MouseButton1Click:connect(function()
	game.ReplicatedStorage.WeatherResources.Settings.AdminEvent:FireServer("Time", GUI.Time.Text)
end)

GUI.Back.MouseButton1Click:connect(function()
	GUI.Visible = false
end)

repeat wait() until game.Players.LocalPlayer ~= nil

game.Players.LocalPlayer:GetMouse().KeyDown:connect(function(Key)
	if Key == game.ReplicatedStorage.WeatherResources.Settings.AdminHotKey.Value then
		GUI.Visible = true
	end
end)