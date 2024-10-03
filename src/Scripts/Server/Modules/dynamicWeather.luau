local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local wsShared = ReplicatedStorage:WaitForChild("WeatherSystem_Shared")
local modules = wsShared:WaitForChild("Modules")
local dynamicWeatherShared = require(modules:WaitForChild("dynamicWeatherShared"))
local EvLightning = require(modules:WaitForChild("EvLightning"))
local configuration = wsShared:WaitForChild("Configuration")
local data = wsShared:WaitForChild("Data")
local types = require(script.Parent.Parent.types)

local isDebug = configuration:GetAttribute("debug")
local print = function(...)
	if isDebug then
		print(`[RTWS Server]: `, ...)
	end
end
-- local warn = function(...)
-- 	if isDebug then
-- 		warn(`[RTWS Server]: `, ...)
-- 	end
-- end

local dynamicWeather = {
	lastAnimateOffset = Vector2.new(),
	animateOffset = Vector2.new(),
	timeElapsed = 0,
} :: types.dynamicWeather

function dynamicWeather._loop(self: types.dynamicWeather, deltaTime: number)
	self.timeElapsed += deltaTime
	if (self.lastAnimateOffset - self.animateOffset).Magnitude > 1 or self.currentWind ~= workspace.GlobalWind then
		self.events.noiseAnimation:fireAll(self:getAnimationData())
		self.lastAnimateOffset = self.animateOffset
		self.currentWind = workspace.GlobalWind
	end
	self.animateOffset += Vector2.new(
		(-workspace.GlobalWind.X / 100) * deltaTime,
		(-workspace.GlobalWind.Z / 100) * deltaTime
	)

	if self.timeElapsed >= 10 and data.temperature.Value > 4.5 then
		local randomPosition = Vector3.new(
			math.random((self.mapSizeMin.X - 50) * 640, (self.mapSizeMax.X - 50) * 640),
			400,
			math.random((self.mapSizeMin.Y - 50) * 640, (self.mapSizeMax.Y - 50) * 640)
		)
		local chunk =
			Vector2.new(math.floor((randomPosition.X + 32000) / 640), math.floor((randomPosition.Z + 32000) / 640))
		local values = dynamicWeatherShared:getValues()
		local elevation = dynamicWeatherShared:calculateElevationAtChunk(
			chunk,
			2.5,
			values.amplitude,
			values.octaves,
			values.persistence,
			values.lacunarity,
			self.randomSeed,
			self.animateOffset
		)
		print("Lightning", self.timeElapsed, randomPosition, chunk, elevation)
		if elevation < 0.15 then
			local bolt = EvLightning.new(
				randomPosition,
				randomPosition - Vector3.new(0, 400, 0),
				{ decay = 0.15, tween_time = 0.15 }
			)
			bolt:Draw()
		end
		self.timeElapsed = 0
	end
end

function dynamicWeather.getAnimationData(self: types.dynamicWeather)
	return self.lastAnimateOffset, self.animateOffset
end

function dynamicWeather.start(self: types.dynamicWeather)
	print("Initializing Dynamic Weather")
	self.mapSize = configuration:GetAttribute("MapSize")
	self.mapSizeMin = Vector2.new((100 - self.mapSize.X) / 2 + 1, (100 - self.mapSize.Y) / 2 + 1)
	self.mapSizeMax = Vector2.new((100 + self.mapSize.X) / 2 + 1, (100 + self.mapSize.Y) / 2 + 1)
	self.lastAnimateOffset = Vector2.new(math.random(-1000, 1000), math.random(-1000, 1000))
	self.animateOffset = self.lastAnimateOffset - Vector2.new(1, 1)
	self.currentWind = workspace.GlobalWind

	self.comm:remoteFunction("getAnimationData", self, "getAnimationData")

	RunService.Heartbeat:Connect(function(deltaTime)
		self:_loop(deltaTime)
	end)

	print("Dynamic Weather Initialized")
end

return dynamicWeather
