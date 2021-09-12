wait(1)
math.randomseed(tick())

local player = game.Players.LocalPlayer
local camera = game.Workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

local Weather = game.ReplicatedStorage.WeatherResources
local WeatherFolder = Weather.Weather
local Current = WeatherFolder.Current
local Parts = Weather.Parts

local Close = {167060276, 236328564, 236328548, 236328533}
local Medium = {167060296, 236328809, 236328781, 236328758}
local Far = {167060342, 167060366, 236328734, 236328715, 236328701, 236328669, 236328595}

--local Cloud = player:WaitForChild("Weather").Cloud
local Clouds
if workspace.Terrain:FindFirstChild("Clouds") then
	Clouds = workspace.Terrain.Clouds
else
	Clouds = Instance.new("Clouds")
end
local Precip = player:WaitForChild("Weather").Precip
local RainModule = require(Weather.Modules.PrecipitationHandlers.Rain)

--Cloud.Value = Parts.PlayerCloud:Clone()
--Cloud.Value.Name = "PlayerCloud"..player.Name
--Cloud.Value.Position = camera.CFrame.Position
--Cloud.Value.Parent = game.Workspace
Clouds.Cover = 0.3
Clouds.Density = 0.5
Clouds.Parent = workspace.Terrain

Precip.Value = Parts.Precip:Clone()
Precip.Value.Name = "Precip"..player.Name
Precip.Value.Position = camera.CFrame.Position + Vector3.new(0, 50, 0)
Precip.Value.Parent = game.Workspace

--[[if Current.Weather.Value == "Drizzle" or
	Current.Weather.Value == "Showers" or
	Current.Weather.Value == "Rain" or
	Current.Weather.Value == "Heavy Rain" or
	Current.Weather.Value == "Thunderstorms" or
	Current.Weather.Value == "Strong Thunderstorms" or
	Current.Weather.Value == "Flurries" or
	Current.Weather.Value == "Snow Showers" or
	Current.Weather.Value == "Snow" or
	Current.Weather.Value == "Heavy Snow" or
	Current.Weather.Value == "Freezing Drizzle" or
	Current.Weather.Value == "Rain / Snow Showers" or
	Current.Weather.Value == "Rain / Snow" or
	Current.Weather.Value == "Heavy Rain / Snow" or
	Current.Weather.Value == "Cloudy" then
	Cloud.Value.Transparency = 0
else Cloud.Value.Transparency = 1 end]]
	
function SetPrecip()
	if Current.Weather.Value == "Drizzle" then
		--Precip.Value.Rain.Enabled = true
		--Precip.Value.Rain.Rate = 100
		RainModule:SetIntensityRatio(0.100)
		RainModule:Enable()
		Precip.Value.Hail.Enabled = false
		Precip.Value.Snow.Enabled = false
	elseif Current.Weather.Value == "Showers" then
		RainModule:SetIntensityRatio(0.200)
		RainModule:Enable()
		Precip.Value.Hail.Enabled = false
		Precip.Value.Snow.Enabled = false
	elseif Current.Weather.Value == "Rain" then
		RainModule:SetIntensityRatio(0.300)
		RainModule:Enable()
		Precip.Value.Hail.Enabled = false
		Precip.Value.Snow.Enabled = false
	elseif Current.Weather.Value == "Heavy Rain" or Current.Weather.Value == "Thunderstorms" then
		RainModule:SetIntensityRatio(0.400)
		RainModule:Enable()
		Precip.Value.Hail.Enabled = false
		Precip.Value.Snow.Enabled = false
	elseif Current.Weather.Value == "Strong Thunderstorms" then
		RainModule:SetIntensityRatio(0.500)
		RainModule:Enable()
		Precip.Value.Hail.Enabled = true
		Precip.Value.Snow.Enabled = false
	elseif Current.Weather.Value == "Flurries" then
		RainModule:Disable()
		Precip.Value.Hail.Enabled = false
		Precip.Value.Snow.Enabled = true
		Precip.Value.Snow.Rate = 100
	elseif Current.Weather.Value == "Snow Showers" then
		RainModule:Disable()
		Precip.Value.Hail.Enabled = false
		Precip.Value.Snow.Enabled = true
		Precip.Value.Snow.Rate = 200
	elseif Current.Weather.Value == "Snow" then
		RainModule:Disable()
		Precip.Value.Hail.Enabled = false
		Precip.Value.Snow.Enabled = true
		Precip.Value.Snow.Rate = 300
	elseif Current.Weather.Value == "Heavy Snow" then
		RainModule:Disable()
		Precip.Value.Hail.Enabled = false
		Precip.Value.Snow.Enabled = true
		Precip.Value.Snow.Rate = 400
	elseif Current.Weather.Value == "Freezing Drizzle" then
		RainModule:SetIntensityRatio(0.100)
		RainModule:Enable()
		Precip.Value.Hail.Enabled = false
		Precip.Value.Snow.Enabled = true
		Precip.Value.Snow.Rate = 100
	elseif Current.Weather.Value == "Rain / Snow Showers" then
		RainModule:SetIntensityRatio(0.200)
		RainModule:Enable()
		Precip.Value.Hail.Enabled = false
		Precip.Value.Snow.Enabled = true
		Precip.Value.Snow.Rate = 200
	elseif Current.Weather.Value == "Rain / Snow" then
		RainModule:SetIntensityRatio(0.300)
		RainModule:Enable()
		Precip.Value.Hail.Enabled = false
		Precip.Value.Snow.Enabled = true
		Precip.Value.Snow.Rate = 300
	elseif Current.Weather.Value == "Heavy Rain / Snow" then
		RainModule:SetIntensityRatio(0.400)
		RainModule:Enable()
		Precip.Value.Hail.Enabled = false
		Precip.Value.Snow.Enabled = true
		Precip.Value.Snow.Rate = 400
	else
		RainModule:Disable()
		Precip.Value.Hail.Enabled = false
		Precip.Value.Snow.Enabled = false
	end
end

function Precipitate()
	wait(1)
	if Current.Weather.Value == "Drizzle" or
	Current.Weather.Value == "Showers" or
	Current.Weather.Value == "Rain" or
	Current.Weather.Value == "Heavy Rain" or
	Current.Weather.Value == "Thunderstorms" or
	Current.Weather.Value == "Strong Thunderstorms" or
	Current.Weather.Value == "Flurries" or
	Current.Weather.Value == "Snow Showers" or
	Current.Weather.Value == "Snow" or
	Current.Weather.Value == "Heavy Snow" or
	Current.Weather.Value == "Freezing Drizzle" or
	Current.Weather.Value == "Rain / Snow Showers" or
	Current.Weather.Value == "Rain / Snow" or
	Current.Weather.Value == "Heavy Rain / Snow" or
	Current.Weather.Value == "Cloudy" then
		local TI = TweenInfo.new(5)
		local Tween = TweenService:Create(Clouds, TI, {Cover = 1, Density = 1})
		Tween:Play()
	elseif Current.Weather.Value == "Partly Cloudy" then
		local TI = TweenInfo.new(5)
		local Tween = TweenService:Create(Clouds, TI, {Cover = 0.3, Density = 0.5})
		Tween:Play()
	elseif Current.Weather.Value == "Mostly Cloudy" then
		local TI = TweenInfo.new(5)
		local Tween = TweenService:Create(Clouds, TI, {Cover = 0.5, Density = 0.5})
		Tween:Play()
	else
		local TI = TweenInfo.new(5)
		local Tween = TweenService:Create(Clouds, TI, {Cover = 0, Density = 0})
		Tween:Play()
	end
	
	SetPrecip()
end


RainModule:SetCollisionMode(
	RainModule.CollisionMode.Function,
	function(p)
		return p.Transparency <= 0.97
	end
)

SetPrecip()

Precipitate()

Current.Weather.Changed:Connect(Precipitate)

game.Workspace.ChildAdded:Connect(function(child)
	if child.Name == "Lightning" then
		local Id
		if player.Character:FindFirstChild("Torso") then
			if (player.Character.Torso.Position - child:WaitForChild("Lightning").Position).magnitude < 1000 then Id = Close[math.random(1, #Close)]
			elseif (player.Character.Torso.Position - child:WaitForChild("Lightning").Position).magnitude < 3000 then Id = Medium[math.random(1, #Medium)]
			else Id = Far[math.random(1, #Far)] end
			local sound = Instance.new("Sound")
			sound.Parent = script
			sound.SoundId = "rbxassetid://"..Id
			sound.Volume = 1
			local pc = math.random(-2, 2) / 10
			sound.PlaybackSpeed = 1 + pc
			sound:Play()
			wait(20)
			sound:remove()
		end
	end
end)

game:GetService("RunService"):BindToRenderStep("Precipitation", Enum.RenderPriority.Camera.Value, function()
	local CFrame = camera.CFrame
	--Cloud.Value.Position = CFrame.Position
	if player.Character:FindFirstChild("Torso") then
		Precip.Value.Position = CFrame.Position + Vector3.new(CFrame.LookVector.x * 50 + player.Character.Torso.Velocity.x, 75, CFrame.LookVector.z * 50 + player.Character.Torso.Velocity.z)
	else
		Precip.Value.Position = CFrame.Position + Vector3.new(CFrame.LookVector.x * 50, 75, CFrame.LookVector.z * 50)
	end
end)