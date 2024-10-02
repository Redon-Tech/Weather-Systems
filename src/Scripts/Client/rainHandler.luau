local ReplicatedStorage = game:GetService("ReplicatedStorage")

local wsShared = ReplicatedStorage:WaitForChild("WeatherSystem_Shared")
local modules = wsShared:WaitForChild("Modules")
local rain = require(modules:WaitForChild("Rain"))
local types = require(script.Parent:WaitForChild("types"))

local rainHandler = {
	rainMode = "rain",
	rainEnabled = false,
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
	rain:SetIntensityRatio(intensity)
end

function rainHandler.enable(self: types.rainHandler)
	self.rainEnabled = true
	rain:Enable()
end

function rainHandler.disable(self: types.rainHandler)
	self.rainEnabled = false
	rain:Disable()
end

return rainHandler
