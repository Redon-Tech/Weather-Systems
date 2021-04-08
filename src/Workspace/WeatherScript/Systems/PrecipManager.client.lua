wait(1)
math.randomseed(tick())

local player = game.Players.LocalPlayer
local camera = game.Workspace.CurrentCamera

local Weather = game.ReplicatedStorage.WeatherResources
local WeatherFolder = Weather.Weather
local Current = WeatherFolder.Current
local Parts = Weather.Parts

local Close = {167060276, 236328564, 236328548, 236328533}
local Medium = {167060296, 236328809, 236328781, 236328758}
local Far = {167060342, 167060366, 236328734, 236328715, 236328701, 236328669, 236328595}

local Cloud = player:WaitForChild("Weather").Cloud
local Precip = player:WaitForChild("Weather").Precip

Cloud.Value = Parts.PlayerCloud:Clone()
Cloud.Value.Name = "PlayerCloud"..player.Name
Cloud.Value.Position = camera.CoordinateFrame.p
if game.Workspace.FilteringEnabled == true then
	Cloud.Value.Parent = game.Workspace
else Cloud.Value.Parent = camera end

Precip.Value = Parts.Precip:Clone()
Precip.Value.Name = "Precip"..player.Name
Precip.Value.Position = camera.CoordinateFrame.p + Vector3.new(0, 50, 0)
if game.Workspace.FilteringEnabled == true then
	Precip.Value.Parent = game.Workspace
else Precip.Value.Parent = camera end

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
	Cloud.Value.Transparency = 0
else Cloud.Value.Transparency = 1 end
	
function SetPrecip()
	if Current.Weather.Value == "Drizzle" then
		Precip.Value.Rain.Enabled = true
		Precip.Value.Rain.Rate = 100
		Precip.Value.Hail.Enabled = false
		Precip.Value.Snow.Enabled = false
	elseif Current.Weather.Value == "Showers" then
		Precip.Value.Rain.Enabled = true
		Precip.Value.Rain.Rate = 200
		Precip.Value.Hail.Enabled = false
		Precip.Value.Snow.Enabled = false
	elseif Current.Weather.Value == "Rain" then
		Precip.Value.Rain.Enabled = true
		Precip.Value.Rain.Rate = 300
		Precip.Value.Hail.Enabled = false
		Precip.Value.Snow.Enabled = false
	elseif Current.Weather.Value == "Heavy Rain" or Current.Weather.Value == "Thunderstorms" then
		Precip.Value.Rain.Enabled = true
		Precip.Value.Rain.Rate = 400
		Precip.Value.Hail.Enabled = false
		Precip.Value.Snow.Enabled = false
	elseif Current.Weather.Value == "Strong Thunderstorms" then
		Precip.Value.Rain.Enabled = true
		Precip.Value.Rain.Rate = 500
		Precip.Value.Hail.Enabled = true
		Precip.Value.Snow.Enabled = false
	elseif Current.Weather.Value == "Flurries" then
		Precip.Value.Rain.Enabled = false
		Precip.Value.Hail.Enabled = false
		Precip.Value.Snow.Enabled = true
		Precip.Value.Snow.Rate = 100
	elseif Current.Weather.Value == "Snow Showers" then
		Precip.Value.Rain.Enabled = false
		Precip.Value.Hail.Enabled = false
		Precip.Value.Snow.Enabled = true
		Precip.Value.Snow.Rate = 200
	elseif Current.Weather.Value == "Snow" then
		Precip.Value.Rain.Enabled = false
		Precip.Value.Hail.Enabled = false
		Precip.Value.Snow.Enabled = true
		Precip.Value.Snow.Rate = 300
	elseif Current.Weather.Value == "Heavy Snow" then
		Precip.Value.Rain.Enabled = false
		Precip.Value.Hail.Enabled = false
		Precip.Value.Snow.Enabled = true
		Precip.Value.Snow.Rate = 400
	elseif Current.Weather.Value == "Freezing Drizzle" then
		Precip.Value.Rain.Enabled = true
		Precip.Value.Rain.Rate = 100
		Precip.Value.Hail.Enabled = false
		Precip.Value.Snow.Enabled = true
		Precip.Value.Snow.Rate = 100
	elseif Current.Weather.Value == "Rain / Snow Showers" then
		Precip.Value.Rain.Enabled = true
		Precip.Value.Rain.Rate = 200
		Precip.Value.Hail.Enabled = false
		Precip.Value.Snow.Enabled = true
		Precip.Value.Snow.Rate = 200
	elseif Current.Weather.Value == "Rain / Snow" then
		Precip.Value.Rain.Enabled = true
		Precip.Value.Rain.Rate = 300
		Precip.Value.Hail.Enabled = false
		Precip.Value.Snow.Enabled = true
		Precip.Value.Snow.Rate = 300
	elseif Current.Weather.Value == "Heavy Rain / Snow" then
		Precip.Value.Rain.Enabled = true
		Precip.Value.Rain.Rate = 400
		Precip.Value.Hail.Enabled = false
		Precip.Value.Snow.Enabled = true
		Precip.Value.Snow.Rate = 400
	else
		Precip.Value.Rain.Enabled = false
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
		repeat wait() until Cloud.Value ~= nil
		if Cloud.Value.Transparency > 0 then
			for i = Cloud.Value.Transparency, 0, -.01 do
				Cloud.Value.Transparency = i
				wait()
				Cloud.Value.Transparency = 0
			end
		end
	else
		repeat wait() until Cloud.Value ~= nil
		if Cloud.Value.Transparency < 1 then
			for i = Cloud.Value.Transparency, 1, .01 do
				Cloud.Value.Transparency = i
				wait()
			end
			Cloud.Value.Transparency = 1
		end
	end
	
	SetPrecip()
end



SetPrecip()

Precipitate()

Current.Weather.Changed:connect(Precipitate)

game.Workspace.ChildAdded:connect(function(child)
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
			sound.Pitch = 1 + pc
			sound:Play()
			wait(20)
			sound:remove()
		end
	end
end)

game:GetService("RunService"):BindToRenderStep("Precipitation", Enum.RenderPriority.Camera.Value, function()
	local CFrame = camera.CoordinateFrame
	Cloud.Value.Position = CFrame.p
	if player.Character:FindFirstChild("Torso") then
		Precip.Value.Position = CFrame.p + Vector3.new(CFrame.lookVector.x * 50 + player.Character.Torso.Velocity.x, 75, CFrame.lookVector.z * 50 + player.Character.Torso.Velocity.z)
	else
		Precip.Value.Position = CFrame.p + Vector3.new(CFrame.lookVector.x * 50, 75, CFrame.lookVector.z * 50)
	end
end)