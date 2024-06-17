wait(1)
local player = game.Players.LocalPlayer

--local Main = script.Parent.Main
--local Small = script.Parent.Small
local New = script.Parent.New

local WeatherFolder = game.ReplicatedStorage:WaitForChild("WeatherResources").Weather
local DayBegin = WeatherFolder.Day.DayBegin.Value
local NightBegin = WeatherFolder.Day.NightBegin.Value
local Settings = WeatherFolder.Parent.Settings

local Current = WeatherFolder.Current
local Monthly = WeatherFolder.Monthly
local ForecastDay = WeatherFolder.ForecastDay
local ForecastNight = WeatherFolder.ForecastNight

local Images = {
	["Sunny"] = 210606383,
	["Clear"] = 211037338,
	["Partly Cloudy"] = 211037317,
	["Partly Cloudy Night"] = 211037326,
	["Mostly Cloudy"] = 211037317,
	["Mostly Cloudy Night"] = 211037326,
	["Cloudy"] = 211037334,
	["Flurries"] = 211037337,
	["Snow Showers"] = 211037312,
	["Snow"] = 211037312,
	["Heavy Snow"] = 211037325,
	["Freezing Drizzle"] = 211037320,
	["Rain / Snow Showers"] = 211037320,
	["Rain / Snow"] = 211037320,
	["Heavy Rain / Snow"] = 211037320,
	["Drizzle"] = 211037321,
	["Showers"] = 211037321,
	["Rain"] = 211037321,
	["Heavy Rain"] = 211037330,
	["Thunderstorms"] = 211037310,
	["Strong Thunderstorms"] = 211037310,
	["Isolated Thunderstorms"] = 211037319,
	["Isolated Thunderstorms Night"] = 211037319,
	["Scattered Thunderstorms"] = 211037319,
	["Scattered Thunderstorms Night"] = 211037319
}

--[[
local Tooltip = script.Parent.Parent.Tooltip

small.CurrentWeather.MouseEnter:connect(function() Tooltip.Text = Current.Weather.Value end)
main.CurrentWeather.MouseEnter:connect(function() Tooltip.Text = Current.Weather.Value end)
main.TodaysWeather.MouseEnter:connect(function()
	local t = game.Lighting:GetMinutesAfterMidnight()
	if t > DayBegin and t < NightBegin then Tooltip.Text = ForecastDay.Weather.Value
	else Tooltip.Text = ForecastNight.Weather.Value end
end)
small.CurrentWeather.MouseLeave:connect(function() Tooltip.Text = "" end)
main.CurrentWeather.MouseLeave:connect(function() Tooltip.Text = "" end)
main.TodaysWeather.MouseLeave:connect(function() Tooltip.Text = "" end)
]]

function GetCurrentWeather()
	local Time = game.Lighting:GetMinutesAfterMidnight()
	local CurrentWeather = Current.Weather.Value
	local CurrentID, Alert

	if Time > DayBegin and Time < NightBegin then
		CurrentID = Images[CurrentWeather]
	else
		if Images[CurrentWeather.." Night"] then CurrentID = Images[CurrentWeather.." Night"]
		else CurrentID = Images[CurrentWeather] end
	end

	if CurrentWeather == "Strong Thunderstorms" or CurrentWeather == "Heavy Rain" or CurrentWeather == "Heavy Rain / Snow" or CurrentWeather == "Heavy Snow" then
		Alert = true
	else Alert = false end

	New.CurrentWeather.Image = "rbxassetid://"..CurrentID
	if Alert == true then New.CurrentWeather.Alert.Image = "rbxassetid://210639854" else New.CurrentWeather.Alert.Image = "" end
	--Main.CurrentWeather.Image = "rbxassetid://"..CurrentID
	--if Alert == true then Main.CurrentWeather.Alert.Image = "rbxassetid://210639854" else Main.CurrentWeather.Alert.Image = "" end

	if not Settings.UseMetric.Value then
		New.CurrentTemp.Text = Current.Temperature.Value.."*F"
		--Main.CurrentTemp.Text = Current.Temperature.Value.."*"
	else
		New.CurrentTemp.Text = math.floor((Current.Temperature.Value - 32) * (5/9)).."*C"
		--Main.CurrentTemp.Text = math.floor((Current.Temperature.Value - 32) * (5/9)).."*"
	end


end

function GetForecastImage(Forecast, target)
	local Time = game.Lighting:GetMinutesAfterMidnight()
	local CurrentID, Alert

	if Time > DayBegin and Time < NightBegin then
		CurrentID = Images[Forecast]
	else
		if Images[Forecast.." Night"] then CurrentID = Images[Forecast.." Night"]
		else CurrentID = Images[Forecast] end
	end

	if Forecast == "Strong Thunderstorms" or Forecast == "Heavy Rain" or Forecast == "Heavy Rain / Snow" or Forecast == "Heavy Snow" then
		Alert = true
	else Alert = false end

	target.Image = "rbxassetid://"..CurrentID
	if Alert == true then target.Alert.Image = "rbxassetid://210639854" else target.Alert.Image = "" end
end

function UpdateWeather()

	--[[local Time = game.Lighting:GetMinutesAfterMidnight()
	if Time > DayBegin and Time < NightBegin then
		Main.Forecast.Text = ForecastDay.Description.Value
		GetForecastImage(ForecastDay.Weather.Value, Main.TodaysWeather)
	else
		Main.Forecast.Text = ForecastNight.Description.Value
		GetForecastImage(ForecastNight.Weather.Value, Main.TodaysWeather)
	end
	
	if not Settings.UseMetric.Value then
		Main.ForecastHigh.Text = ForecastDay.Temperature.Value.."F"
		Main.ForecastLow.Text = ForecastNight.Temperature.Value.."F"
	else
		Main.ForecastHigh.Text = math.floor((ForecastDay.Temperature.Value - 32) * (5/9)).."C"
		Main.ForecastLow.Text = math.floor((ForecastNight.Temperature.Value - 32) * (5/9)).."C"
	end]]

end

New.Date.Text = Current.Parent.Day.Value

Current.Parent.Day.Changed:Connect(function(Date) New.Date.Text = Date end)
Current.Temperature.Changed:Connect(GetCurrentWeather)
Current.Weather.Changed:Connect(GetCurrentWeather)
game.Lighting.Changed:Connect(function(Property) if Property == "TimeOfDay" then UpdateWeather() end end)

--[[Small.Open.MouseButton1Click:connect(function()
	Small.Visible = false
	Main.Visible = true
end)

Main.Close.MouseButton1Click:connect(function()
	Small.Visible = true
	Main.Visible = false
end)]]

GetCurrentWeather()
UpdateWeather()