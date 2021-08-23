local Settings = game.ReplicatedStorage:WaitForChild("WeatherResources"):WaitForChild("Settings")

--if Settings.EnableForecast.Value and Settings.LockTime.Value == "" then script.Weather.Small.Visible = true else script.Weather.Date.Position = UDim2.new(0.5, -43, 0, 0) end
--if Settings.EnableDate.Value and Settings.LockTime.Value == "" and Settings.LockMonth.Value == "" then script.Weather.Date.Visible = true end
if Settings.EnableForecast.Value == false then
	script.Weather.New.CurrentWeather.Visible = false
	script.Weather.New.CurrentTemp.Visible = false
end
if Settings.EnableDate.Value == false then
	script.Weather.New.Date.Visible = false
end
script.Weather.WeatherGUI.Disabled = false
script.Weather.Parent = game.StarterGui

local AveTemps = Settings.AverageTemps
local AvePrecip = Settings.AveragePrecip

local AverageHighTemps = {
	["Jan"] = AveTemps.January.MaxValue,
	["Feb"] = AveTemps.February.MaxValue,
	["Mar"] = AveTemps.March.MaxValue,
	["Apr"] = AveTemps.April.MaxValue,
	["May"] = AveTemps.May.MaxValue,
	["Jun"] = AveTemps.June.MaxValue,
	["Jul"] = AveTemps.July.MaxValue,
	["Aug"] = AveTemps.August.MaxValue,
	["Sep"] = AveTemps.September.MaxValue,
	["Oct"] = AveTemps.October.MaxValue,
	["Nov"] = AveTemps.November.MaxValue,
	["Dec"] = AveTemps.December.MaxValue
}

local AverageLowTemps = {
	["Jan"] = AveTemps.January.MinValue,
	["Feb"] = AveTemps.February.MinValue,
	["Mar"] = AveTemps.March.MinValue,
	["Apr"] = AveTemps.April.MinValue,
	["May"] = AveTemps.May.MinValue,
	["Jun"] = AveTemps.June.MinValue,
	["Jul"] = AveTemps.July.MinValue,
	["Aug"] = AveTemps.August.MinValue,
	["Sep"] = AveTemps.September.MinValue,
	["Oct"] = AveTemps.October.MinValue,
	["Nov"] = AveTemps.November.MinValue,
	["Dec"] = AveTemps.December.MinValue
}

local LengthOfDay = 10

local SeasonPrecip = {
	["Spring"] = AvePrecip.Spring.Value / 100,
	["Summer"] = AvePrecip.Summer.Value / 100,
	["Fall"] = AvePrecip.Autumn.Value / 100,
	["Winter"] = AvePrecip.Winter.Value / 100
}

local DayBegin = 380 --6:20

local NightBegin = 1070 --5:20

math.randomseed(tick())
math.random(0, 1)

local Resources = game.ReplicatedStorage:WaitForChild("WeatherResources")

local WeatherFolder = Resources:WaitForChild("Weather")
local Day = WeatherFolder.Day
local Season
local CurrentDay = math.random(1, 365)
local CurrentMonth
local Current = WeatherFolder.Current
local Monthly = WeatherFolder.Monthly
local ForecastDay = WeatherFolder.ForecastDay
local ForecastNight = WeatherFolder.ForecastNight

Day.DayBegin.Value = DayBegin
Day.NightBegin.Value = NightBegin

local PartsFolder = Resources:WaitForChild("Parts")
--local LargeCloud = PartsFolder.Cloud
--LargeCloud.Parent = game.Workspace

local SoundsFolder = Resources:WaitForChild("Sounds")
local Ambience = SoundsFolder.Ambience
local Rain = SoundsFolder.Rain
local Hail = SoundsFolder.Hail

Ambience.Parent = game.Workspace
Rain.Parent = game.Workspace
Hail.Parent = game.Workspace

repeat
	Ambience:Play()
	Rain:Play()
	Hail:Play()
	wait()
until Ambience.IsPlaying == true and Rain.IsPlaying == true and Hail.IsPlaying == true


local ModuleFolder = Resources:WaitForChild("Modules")

local ModuleFunctions = {
	["TweenCloud"] = require(ModuleFolder.Cloud),
	["SpawnLightning"] = require(ModuleFolder.Lightning),
	["GetWeather"] = require(ModuleFolder.GetWeather),
	["SetLights"] = require(ModuleFolder.SetLights),
	["CreateClouds"] = require(ModuleFolder.CreateClouds),
	["GetDescription"] = require(ModuleFolder.GetDescription),
}

local Lights, Gantries = {}, {}
local Lighting = game.Lighting
local Lightning = PartsFolder.Lightning
local Identifier = "TTPPluginIdentifier"

for _, Child in pairs(game.Workspace:GetChildren()) do
	if Child.Name == "Gantry" and Child:FindFirstChild(Identifier) then table.insert(Gantries, Child)
	elseif Child.Name == "Light" and Child:FindFirstChild(Identifier) then table.insert(Lights, Child)
	end
end

ModuleFunctions["CreateClouds"]()
local SmallClouds = game.Workspace.SmallClouds

local Months = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}

function CalculateDay(DayNumber, IsFirst)
	
	if Settings.LockMonth.Value == "" then
	
		local Month, Subtraction
		if DayNumber <= 31 then
			Month = "January"
			Subtraction = 0
		elseif DayNumber > 31 and DayNumber <= 59 then
			Month = "February"
			Subtraction = 31
		elseif DayNumber > 59 and DayNumber <= 90 then
			Month = "March"
			Subtraction = 59
		elseif DayNumber > 90 and DayNumber <= 120 then
			Month = "April"
			Subtraction = 90
		elseif DayNumber > 120 and DayNumber <= 151 then
			Month = "May"
			Subtraction = 120
		elseif DayNumber > 151 and DayNumber <= 181 then
			Month = "June"
			Subtraction = 151
		elseif DayNumber > 181 and DayNumber <= 212 then
			Month = "July"
			Subtraction = 181
		elseif DayNumber > 212 and DayNumber <= 243 then
			Month = "August"
			Subtraction = 212
		elseif DayNumber > 243 and DayNumber <= 273 then
			Month = "September"
			Subtraction = 243
		elseif DayNumber > 273 and DayNumber <= 304 then
			Month = "October"
			Subtraction = 273
		elseif DayNumber > 304 and DayNumber <= 334 then
			Month = "November"
			Subtraction = 304
		elseif DayNumber > 334 and DayNumber <= 365 then
			Month = "December"
			Subtraction = 334
		end
		
		Day.Value = Month.." "..DayNumber - Subtraction
		CurrentMonth = string.sub(Month, 1, 3)
	
	else
		for i = 1, #Months do if Months[i] == Settings.LockMonth.Value then DayNumber = 15 + (i * 30) CurrentMonth = string.sub(Months[i], 1, 3) end end
		
	end
	
	if DayNumber < 80 or DayNumber >= 355 then
		Season = "Winter"
	elseif DayNumber >= 80 and DayNumber < 172 then
		Season = "Spring"
	elseif DayNumber >= 172 and DayNumber < 264 then
		Season = "Summer"
	elseif DayNumber >= 264 and DayNumber < 355 then
		Season = "Fall"
	else print("RIP SEASONS: "..DayNumber) end
		
	if IsFirst == true then
		if Settings.LockTime.Value == "" then Lighting:SetMinutesAfterMidnight(340)
		else Lighting.TimeOfDay = Settings.LockTime.Value end
		Current.Temperature.Value = AverageLowTemps[CurrentMonth]
		if not Settings.UseWeatherBounds.Value then
			Current.Weather.Value = "Clear"
		else
			local Storm
			if Season == "Summer" then Storm = 2 else Storm = 0 end
			Current.Weather.Value = ModuleFunctions["GetWeather"].String(Settings.WeatherBounds.MinValue, AverageLowTemps[CurrentMonth], "Night", Storm)
		end
		ForecastDay.Temperature.Value = AverageHighTemps[CurrentMonth]
		ForecastDay.Weather.Value = "Sunny"
		ForecastNight.Temperature.Value = AverageLowTemps[CurrentMonth]
		ForecastNight.Weather.Value = "Clear"
	end
end

function DetermineWeather()
	
	local NewHigh = math.ceil((math.random(ForecastNight.Temperature.Value + 7, ForecastNight.Temperature.Value + 15) + AverageHighTemps[CurrentMonth]) / 2)
	local NewLow = math.ceil((math.random(NewHigh - 15, NewHigh - 7) + AverageLowTemps[CurrentMonth]) / 2) 
	
	for TimeOfDay = 1, 2 do
		
		local NewWeather, NewTemperature, NewChance, Chance
		local Storm = 0

		if TimeOfDay == 1 then NewTemperature = NewHigh else NewTemperature = NewLow end
		
		Chance = math.random(1, 1 / SeasonPrecip[Season])
				
		if Chance == 1 then
			if math.random(1, 4) == 1 then
				NewChance = math.random(7, 10) * 10
			else
				NewChance = math.random(2, 6) * 10
			end
		else
			NewChance = math.random(0, 1) * 10
		end
		
		if NewChance == 0 or NewChance == 10 then NewWeather = math.random(1, 3)
		elseif NewChance == 20 then NewWeather = math.random(2, 4)
		elseif NewChance == 30 then NewWeather = math.random(5, 6)
			if Season == "Summer" then
				if NewTemperature > 65 then Storm = 1 end
			elseif Season == "Spring" then
				if NewTemperature > 65 and math.random(0, 109) < CurrentDay - 80 then Storm = 1 end
			elseif Season == "Fall" then
				if NewTemperature > 65 and math.random(0, 40) < CurrentDay - 155 then Storm = 1 end
			end
		elseif NewChance == 40 or NewChance == 50 or NewChance == 60 then NewWeather = 6
			if Season == "Summer" then
				if NewTemperature > 65 then Storm = 1 end
			elseif Season == "Spring" then
				if NewTemperature > 65 and math.random(0, 109) < CurrentDay - 80 then Storm = 1 end
			elseif Season == "Fall" then
				if NewTemperature > 65 and math.random(0, 40) < CurrentDay - 155 then Storm = 1 end
			end
		else NewWeather = math.random(7, 8)
			if Season == "Summer" then
				if NewTemperature > 65 then Storm = 1 end
			elseif Season == "Spring" then
				if NewTemperature > 65 and math.random(0, 109) < CurrentDay - 80 then Storm = 1 end
			elseif Season == "Fall" then
				if NewTemperature > 65 and math.random(0, 40) < CurrentDay - 155 then Storm = 1 end
			end
		end
		
		if Settings.UseWeatherBounds.Value then
			if NewWeather > Settings.WeatherBounds.MaxValue then NewWeather = Settings.WeatherBounds.MaxValue
			elseif NewWeather < Settings.WeatherBounds.MinValue then NewWeather = Settings.WeatherBounds.MinValue end
				
			if Season == "Summer" then
				if NewTemperature > 65 then Storm = 1 end
			elseif Season == "Spring" then
				if NewTemperature > 65 and math.random(0, 109) < CurrentDay - 80 then Storm = 1 end
			elseif Season == "Fall" then
				if NewTemperature > 65 and math.random(0, 40) < CurrentDay - 155 then Storm = 1 end
			end
			
			if Settings.WeatherBounds.MinValue >= 5 then NewChance = 100 end
		end
		
		if TimeOfDay == 1 then
			ForecastDay.Temperature.Value = NewTemperature
			ForecastDay.Weather.Value = ModuleFunctions["GetWeather"].String(NewWeather, NewTemperature, "Day", Storm)
			ForecastDay.Weather.Chance.Value = NewChance
			ForecastDay.Description.Value = ModuleFunctions["GetDescription"]("Day", ForecastDay.Weather.Value, NewChance, ForecastDay.Temperature.Value)
		else
			ForecastNight.Temperature.Value = NewTemperature
			ForecastNight.Weather.Value = ModuleFunctions["GetWeather"].String(NewWeather, NewTemperature, "Night", Storm)
			ForecastNight.Weather.Chance.Value = NewChance
			ForecastNight.Description.Value = ModuleFunctions["GetDescription"]("Night", ForecastNight.Weather.Value, NewChance, ForecastNight.Temperature.Value)
		end
		
--		graphs for weather that's already happened..?
		
	end
end

Current.Weather.Changed:connect(function(NewWeather)
	
	local Multipliers = {
		["Rain"] = 0,
		["Hail"] = 0,
		["Snow"] = 0,
	}
	
	if NewWeather == "Showers" or NewWeather == "Rain" or NewWeather == "Heavy Rain" or NewWeather == "Thunderstorms" or NewWeather == "Strong Thunderstorms" then
		
		local TweenClouds = coroutine.wrap(function()
			--ModuleFunctions["TweenCloud"](1, 0, SmallClouds:GetChildren(), {LargeCloud}, 20)
		end)
		
		local TweenSounds = coroutine.wrap(function()
			if NewWeather == "Showers" then
				Multipliers["Rain"] = 2
			elseif NewWeather == "Rain" or NewWeather == "Thunderstorms" then
				Multipliers["Rain"] = 3
			elseif NewWeather == "Heavy Rain" then
				Multipliers["Rain"] = 4
			elseif NewWeather == "Strong Thunderstorms" then
				Multipliers["Rain"] = 4
				Multipliers["Hail"] = 3
			end
			
			Lighting.FogEnd = 2000 - (Multipliers["Rain"] * 100)
			
			local Interval = ((1 / (5 - Multipliers["Rain"])) - Rain.Volume) * .1
			for i = 1, 10 do
				wait(.2)
				Rain.Volume = Rain.Volume + Interval
			end
			
			local Interval = (Multipliers["Hail"] - Hail.Volume) * .1
			for i = 1, 10 do
				wait(.2)
				Hail.Volume = Hail.Volume + Interval
			end
		end)
		
		TweenClouds()
		TweenSounds()
		
		
	elseif NewWeather == "Flurries" or NewWeather == "Snow Showers" or NewWeather == "Snow" or NewWeather == "Heavy Snow" then
		
		local TweenClouds = coroutine.wrap(function()
			--ModuleFunctions["TweenCloud"](1, 0, SmallClouds:GetChildren(), {LargeCloud}, 20)
		end)
		
		local TweenSounds = coroutine.wrap(function()
			if NewWeather == "Flurries" then Multipliers["Snow"] = 1
			elseif NewWeather == "Snow Showers" then Multipliers["Snow"] = 2
			elseif NewWeather == "Snow" then Multipliers["Snow"] = 3
			elseif NewWeather == "Heavy Snow" then Multipliers["Snow"] = 4 end
			Lighting.FogEnd = 2000 - (Multipliers["Snow"] * 150)
			
			local Interval = -(Rain.Volume) * .1
			for i = 1, 10 do
				wait(.2)
				Rain.Volume = Rain.Volume + Interval
			end
			
			local Interval = -(Hail.Volume) * .1
			for i = 1, 10 do
				wait(.2)
				Hail.Volume = Hail.Volume + Interval
			end
		end)
		
		TweenClouds()
		TweenSounds()
		
	elseif NewWeather == "Rain / Snow Showers" or NewWeather == "Rain / Snow" or NewWeather == "Heavy Rain / Snow" then
		
		local TweenClouds = coroutine.wrap(function()
			--ModuleFunctions["TweenCloud"](1, 0, SmallClouds:GetChildren(), {LargeCloud}, 20)
		end)

		local TweenSounds = coroutine.wrap(function()
			if NewWeather == "Rain / Snow Showers" then
				Multipliers["Snow"] = 2
				Multipliers["Rain"] = 1
			elseif NewWeather == "Rain / Snow" then
				Multipliers["Snow"] = 3
				Multipliers["Rain"] = 2
			elseif NewWeather == "Heavy Rain / Snow" then
				Multipliers["Snow"] = 4
				Multipliers["Rain"] = 3
			end
			
			Lighting.FogEnd = 2000 - (Multipliers["Snow"] * 125)
			
			local Interval = ((1 / (5 - Multipliers["Rain"])) - Rain.Volume) * .1
			for i = 1, 10 do
				wait(.2)
				Rain.Volume = Rain.Volume + Interval
			end
			
			local Interval = -(Hail.Volume) / 10
			for i = 1, 10 do
				wait(.2)
				Hail.Volume = Hail.Volume + Interval
			end
		end)
		
		TweenClouds()
		TweenSounds()
		
	elseif NewWeather == "Sunny" or NewWeather == "Clear" then
		
		local TweenClouds = coroutine.wrap(function()
			--ModuleFunctions["TweenCloud"](1, 1, SmallClouds:GetChildren(), {LargeCloud}, 20)
		end)
		
		local TweenSounds = coroutine.wrap(function()
			Lighting.FogEnd = 2000
			
			local Interval = -(Rain.Volume) / 10
			for i = 1, 10 do
				wait(.2)
				Rain.Volume = Rain.Volume + Interval
			end
			
			local Interval = -(Hail.Volume) / 10
			for i = 1, 10 do
				wait(.2)
				Hail.Volume = Hail.Volume + Interval
			end
		end)
		
		TweenClouds()
		TweenSounds()
		
	elseif NewWeather == "Partly Cloudy" or NewWeather == "Mostly Cloudy" then
		
		local TweenClouds = coroutine.wrap(function()
			--ModuleFunctions["TweenCloud"](0, 1, SmallClouds:GetChildren(), {LargeCloud}, 20)
		end)
		
		local TweenSounds = coroutine.wrap(function()
			Lighting.FogEnd = 2000
			
			local Interval = -(Rain.Volume) / 10
			for i = 1, 10 do
				wait(.2)
				Rain.Volume = Rain.Volume + Interval
			end
			
			local Interval = -(Hail.Volume) / 10
			for i = 1, 10 do
				wait(.2)
				Hail.Volume = Hail.Volume + Interval
			end
		end)
		
		TweenClouds()
		TweenSounds()
		
	elseif NewWeather == "Cloudy" or NewWeather == "Drizzle" or NewWeather == "Freezing Drizzle" then
		
		local TweenClouds = coroutine.wrap(function()
			--ModuleFunctions["TweenCloud"](1, 0, SmallClouds:GetChildren(), {LargeCloud}, 20)
		end)
		
		local TweenSounds = coroutine.wrap(function()
			
			local Interval = -(Rain.Volume) / 10
			for i = 1, 10 do
				wait(.2)
				Rain.Volume = Rain.Volume + Interval
			end
			
			local Interval = -(Hail.Volume) / 10
			for i = 1, 10 do
				wait(.2)
				Hail.Volume = Hail.Volume + Interval
			end
		end)
		
		TweenClouds()
		TweenSounds()
		
	end
	
	if NewWeather == "Thunderstorms" or NewWeather == "Strong Thunderstorms" then
		local Chance
		if NewWeather == "Thunderstorms" then Chance = 15 else Chance = 30 end
		repeat
			wait(math.random(1,4))
			if math.random(1, 100) < Chance then ModuleFunctions["SpawnLightning"]() end
		until Current.Weather.Value ~= "Thunderstorms" and Current.Weather.Value ~= "Strong Thunderstorms"
	end
	
end)

game.Lighting.Changed:connect(function(Property)
	if Property == "TimeOfDay" then
		
		local Time = game.Lighting:GetMinutesAfterMidnight()
		local ForeHigh = ForecastDay.Temperature
		local ForeLow = ForecastNight.Temperature
		
		if Time == 0 then
			
			CurrentDay = CurrentDay + 1
			if CurrentDay == 366 then CurrentDay = 1 end
			CalculateDay(CurrentDay, false)
			
		elseif Time == DayBegin then
			
			DetermineWeather()
			ModuleFunctions["SetLights"](false, Lights, Gantries)
			local XAxis = (Current.Temperature.Value + math.random(ForeHigh.Value - 1, ForeHigh.Value + 1)) / 2
			local Amplitude = Current.Temperature.Value - XAxis
			local Temps = (math.random(NightBegin - 60, NightBegin) - Time) * .5
			for i = 1, Temps do wait(2) Current.Temperature.Value = math.floor(XAxis + (Amplitude * math.cos((i * math.pi) / Temps))) end
			
		elseif Time == NightBegin then
			
			ModuleFunctions["SetLights"](true, Lights, Gantries)
			local XAxis = (Current.Temperature.Value + math.random(ForeLow.Value - 1, ForeLow.Value + 1)) / 2
			local Amplitude = Current.Temperature.Value - XAxis
			local Temps = ((1440 - Time) + math.random(DayBegin - 60, DayBegin)) * .5
			for i = 1, Temps do wait(2) Current.Temperature.Value = math.floor(XAxis + (Amplitude * math.cos((i * math.pi) / Temps))) end
		
		end
		
	end
end)


CalculateDay(CurrentDay, true)
DetermineWeather()

Settings.AdminEvent.OnServerEvent:connect(function(Player, Type, Data)
	if game.ServerStorage.TTPPluginAdmins:FindFirstChild(Player.Name) or Player.UserId == game.CreatorId then
		if Type == "Weather" then
			if Data == "Auto" then Settings.CustomWeather.Value = "" else Settings.CustomWeather.Value = Data end
		end
	end
end)

--[[game.Players.PlayerAdded:connect(function(Player)
	if game.ServerStorage.TTPPluginAdmins:FindFirstChild(Player.Name) or Player.UserId == game.CreatorId then
		Player.CharacterAdded:connect(function(Character)
			local AdminGUI = script.Admin:Clone()
			AdminGUI.WeatherAdmin.Disabled = false
			AdminGUI.Parent = Player.PlayerGui
		end)
	end
end)]]

game.ReplicatedStorage.WeatherFunction.OnServerInvoke = function(plr)
	if game.ServerStorage.TTPPluginAdmins:FindFirstChild(plr.Name) or plr.UserId == game.CreatorId then
		return true
	else
		return false
	end
end

Settings.CustomWeather.Changed:Connect(function(Value)
	if Value ~= "" then Current.Weather.Value = Value end
end)

while 1 < 2 do
	
	local CurrentWeather = ModuleFunctions["GetWeather"].Number(Current.Weather.Value)
	local Time = game.Lighting:GetMinutesAfterMidnight()
	local TargetWeather, TimeOfDay
	local Storm = 0
	if Time > DayBegin and Time < NightBegin then
		TargetWeather = ModuleFunctions["GetWeather"].Number(ForecastDay.Weather.Value)
		if string.find(ForecastDay.Weather.Value, "Thunderstorms") then Storm = 2 end
	else
		TargetWeather = ModuleFunctions["GetWeather"].Number(ForecastNight.Weather.Value)
		if string.find(ForecastNight.Weather.Value, "Thunderstorms") then Storm = 2 end
	end
	
	local Old, New, TweenTime, UpperBound, LowerBound
	
	Old = CurrentWeather
	
	if Settings.UseWeatherBounds.Value then
		UpperBound = Settings.WeatherBounds.MaxValue
		LowerBound = Settings.WeatherBounds.MinValue
	end
	
	if TargetWeather > CurrentWeather then
		New = math.random(CurrentWeather + 1, TargetWeather)
		if Storm == 2 then TweenTime = math.random(45, 90) --Thunderstorms occur more suddenly
		else TweenTime = math.random(120, 180) end
	elseif CurrentWeather > TargetWeather then
		New = math.random(TargetWeather, CurrentWeather - 1)
		TweenTime = math.random(120, 180)
	elseif CurrentWeather == TargetWeather then
		if Settings.UseWeatherBounds.Value then
			if Storm == 2 then
				local LowRandom
				if CurrentWeather - 3 > LowerBound then LowRandom = CurrentWeather - 3
				else LowRandom = LowerBound end
				New = math.random(LowRandom, CurrentWeather)
				TweenTime = math.random(60, 120)
			else
				local LowRandom, HighRandom
				if CurrentWeather - 1 > LowerBound then LowRandom = CurrentWeather - 1
				else LowRandom = LowerBound end
				if CurrentWeather + 1 > UpperBound then HighRandom = CurrentWeather + 1
				else HighRandom = UpperBound end
				New = math.random(LowRandom, HighRandom)
				TweenTime = math.random(120, 180)
			end
		else
			if Storm == 2 then
				New = math.random(CurrentWeather - 3, CurrentWeather)
				TweenTime = math.random(60, 120)
			else
				New = math.random(CurrentWeather - 1, CurrentWeather + 1)
				TweenTime = math.random(120, 180)
			end
		end
		if New <= 0 then New = 1
		elseif New > CurrentWeather then New = CurrentWeather end
		
	end
		
	for i = 1, TweenTime do
		
		if Settings.CustomWeather.Value == "" then
			wait(1)
			local Time = game.Lighting:GetMinutesAfterMidnight()
			if Time > DayBegin and Time < NightBegin then
				TimeOfDay = "Day"
				if string.find(ForecastDay.Weather.Value, "Thunderstorms") then Storm = 2 end
			else
				TimeOfDay = "Night"
				if string.find(ForecastNight.Weather.Value, "Thunderstorms") then Storm = 2 end
			end
			local PrecipNumber = ((Old - New) / 2) + New + (((Old - New) / 2) * math.cos((i * math.pi) / TweenTime))
			Current.Weather.Value = ModuleFunctions["GetWeather"].String(math.floor(PrecipNumber),
				Current.Temperature.Value,
				TimeOfDay,
				Storm)
		
		else
			wait()
			Current.Weather.Value = Settings.CustomWeather.Value		
			
		end
	end
	wait(math.random(30, 60))
end

--	FORMULA FOR ACHIEVING A GRADUAL TRANSITION BETWEEN TWO VALUES OVER A GIVEN DURATION OF TIME

-- ((current - target) / 2) + target + (((current - target) / 2) * math.cos((currenttime * math.pi) / lengthoftime))
