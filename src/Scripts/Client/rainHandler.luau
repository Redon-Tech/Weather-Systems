local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Terrain = workspace:WaitForChild("Terrain")
local RunService = game:GetService("RunService")

local wsShared = ReplicatedStorage:WaitForChild("WeatherSystem_Shared")
local modules = wsShared:WaitForChild("Modules")
local rain = require(modules:WaitForChild("Rain"))
local types = require(script.Parent:WaitForChild("types"))

local rainHandler = {
	rainMode = "rain",
	rainEnabled = false,
	cloudsSetup = false,
	cloudData = {
		cover = 0,
		density = 0,
	},
} :: types.rainHandler

function rainHandler.setSnow(self: types.rainHandler)
	self.rainMode = "snow"
	rain:SetSoundId("rbxassetid://0")
	rain:SetSplashTexture("rbxassetid://0")
	rain:SetStraightTexture("rbxassetid://29510111", NumberSequence.new(1))
	rain:SetTopDownTexture("rbxassetid://29510111", NumberSequence.new(1))
end

function rainHandler.setRain(self: types.rainHandler)
	self.rainMode = "rain"
	rain:SetSoundId("rbxassetid://1516791621")
	rain:SetSplashTexture("rbxassetid://1822856633")
	rain:SetStraightTexture("rbxassetid://1822883048", NumberSequence.new(10))
	rain:SetTopDownTexture(
		"rbxassetid://1822856633",
		NumberSequence.new({
			NumberSequenceKeypoint.new(0, 5.33, 2.75),
			NumberSequenceKeypoint.new(1, 5.33, 2.75),
		})
	)
end

function rainHandler.setIntensity(self: types.rainHandler, intensity: number)
	rain:SetIntensityRatio(intensity, TweenInfo.new(30))
end

function rainHandler.enable(self: types.rainHandler)
	self.rainEnabled = true
	rain:Enable()
end

function rainHandler.disable(self: types.rainHandler)
	self.rainEnabled = false
	rain:Disable()
end

function rainHandler.setCloud(self: types.rainHandler, cover: number, density: number, noTween: boolean?)
	if self.clouds == nil then
		return
	end
	local ti: TweenInfo
	if noTween == true or self.cloudsSetup == false then
		ti = TweenInfo.new(0)
		self.cloudsSetup = true
	else
		ti = TweenInfo.new(30)
	end

	-- self.clouds.Cover = cover
	-- self.clouds.Density = density
	self.cloudData = {
		cover = cover,
		density = density,
	}
	TweenService:Create(self.clouds, ti, { Cover = cover, Density = density }):Play()
end

function rainHandler.start(self: types.rainHandler)
	local clouds = Terrain:FindFirstChildOfClass("Clouds")
	if clouds == nil then
		clouds = Instance.new("Clouds")
		clouds.Parent = Terrain
	end
	self.clouds = clouds

	local cloudConnection: RBXScriptConnection? = nil
	local function onCloudsChanged()
		if clouds.Parent == nil then
			RunService.Heartbeat:Wait()
			rain:TerrainCleared()
			print("Clouds got destroyed, recreating")
			clouds = Instance.new("Clouds")
			clouds.Parent = Terrain
			clouds.Cover = self.cloudData.cover
			clouds.Density = self.cloudData.density
			self.clouds = clouds
			self.cloudsSetup = false

			if cloudConnection then
				cloudConnection:Disconnect()
			end

			cloudConnection = clouds:GetPropertyChangedSignal("Parent"):Connect(onCloudsChanged)
		end
	end
	cloudConnection = clouds:GetPropertyChangedSignal("Parent"):Connect(onCloudsChanged)
end

return rainHandler
