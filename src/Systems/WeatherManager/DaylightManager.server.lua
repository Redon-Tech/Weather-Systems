wait(1)

local Settings = game.ReplicatedStorage:WaitForChild("WeatherResources"):WaitForChild("Settings")

local WeatherFolder = game.ReplicatedStorage:WaitForChild("WeatherResources").Weather
local Current = WeatherFolder.Current
local Monthly = WeatherFolder.Monthly
local ForecastDay = WeatherFolder.ForecastDay
local ForecastNight = WeatherFolder.ForecastNight

function Color(C) return Color3.new(C/255, C/255, C/255) end

function FogColor(value)
	if Current.Weather.Value == "Flurries" or Current.Weather.Value == "Snow Showers" or Current.Weather.Value == "Snow" or Current.Weather.Value == "Heavy Snow" then game.Lighting.FogColor = Color(value + (value * .4))
	elseif Current.Weather.Value == "Flurries" or Current.Weather.Value == "Snow Showers" or Current.Weather.Value == "Snow" or Current.Weather.Value == "Heavy Snow" then game.Lighting.FogColor = Color(value + (value * .3))
	else game.Lighting.FogColor = Color(value) end
end

function ChangeLighting()
	local Time = game.Lighting:GetMinutesAfterMidnight()
	print(Time)
	if Time >= 360 and Time < 1080 then
		local Difference = Time - 360
		if Difference > 30 then Difference = 30 end
		local Light = 120 + (-50 * math.cos((Difference * math.pi) / 30))
		game.Lighting.Ambient = Color(Light)
		game.Lighting.OutdoorAmbient = Color(Light)
		game.Lighting.FogColor = Color(Light)
	elseif Time >= 1080 or Time < 360 then
		local Difference
		if Time >= 1080 then Difference = Time - 1080 else Difference = Time + 360 end
		if Difference > 30 then Difference = 30 end
		local Light = 120 + (50 * math.cos((Difference * math.pi) / 30))
		game.Lighting.Ambient = Color(Light)
		game.Lighting.OutdoorAmbient = Color(Light)
		game.Lighting.FogColor = Color(Light)
	end
end

Settings.AdminEvent.OnServerEvent:connect(function(Player, Type, Data)
	if game.ServerStorage.TTPPluginAdmins:FindFirstChild(Player.Name) or Player.UserId == game.CreatorId then
		if Type == "Time" then
			game.Lighting.TimeOfDay = Data
			local Time = game.Lighting:GetMinutesAfterMidnight()
			if Time >= 360 and Time <= 390 then
				for i = 1 + (Time - 360), 390 - Time do
					local CurrentTime = game.Lighting:GetMinutesAfterMidnight()
					if CurrentTime >= 360 and CurrentTime <= 390 then
						local Light = 120 + (-50 * math.cos((i * math.pi) / 30))
						game.Lighting.Ambient = Color(Light)
						game.Lighting.OutdoorAmbient = Color(Light)
						game.Lighting.FogColor = Color(Light)
						wait(1)
					else break
					end
				end
			elseif Time >= 1080 and Time <= 1110 then
				for i = 1 + (Time - 1080), 1110 - Time do
					local CurrentTime = game.Lighting:GetMinutesAfterMidnight()
					if CurrentTime >= 1080 and CurrentTime <= 1110 then
						local Light = 120 + (50 * math.cos((i * math.pi) / 30))
						game.Lighting.Ambient = Color(Light)
						game.Lighting.OutdoorAmbient = Color(Light)
						game.Lighting.FogColor = Color(Light)
						wait(1)
					else break
					end
				end
			end
		end
	end
end)

if WeatherFolder.Parent.Settings.LockTime.Value ~= "" then
	game.Lighting.TimeOfDay = WeatherFolder.Parent.Settings.LockTime.Value
	ChangeLighting()
	
else
	game.Lighting.Changed:connect(function(prop)
		if prop == "TimeOfDay" then
			local Time = game.Lighting:GetMinutesAfterMidnight()
			if Time == 360 then
				for i = 1, 30 do
					local CurrentTime = game.Lighting:GetMinutesAfterMidnight()
					if CurrentTime >= 360 and CurrentTime <= 390 then
						local Light = 120 + (-50 * math.cos((i * math.pi) / 30))
						game.Lighting.Ambient = Color(Light)
						game.Lighting.OutdoorAmbient = Color(Light)
						game.Lighting.FogColor = Color(Light)
						wait(1)
					else break
					end
				end
			elseif Time == 1080 then
				for i = 1, 30 do
					local CurrentTime = game.Lighting:GetMinutesAfterMidnight()
					if CurrentTime >= 1080 and CurrentTime <= 1110 then
						local Light = 120 + (50 * math.cos((i * math.pi) / 30))
						game.Lighting.Ambient = Color(Light)
						game.Lighting.OutdoorAmbient = Color(Light)
						game.Lighting.FogColor = Color(Light)
						wait(1)
					else break
					end
				end
			end
			
		end
	end)
	
	repeat
		game.Lighting:SetMinutesAfterMidnight(game.Lighting:GetMinutesAfterMidnight() + .5)
		wait(.5)
	until 1 == 0
	
end

