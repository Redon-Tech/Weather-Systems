local dynamicWeather = {
	map = table.create(101, table.create(101, 0)),
	lastAnimateOffset = Vector2.new(1, 1),
	animateOffset = Vector2.new(0, 0),
	octaves = 8,
	lacunarity = 3,
	persistence = 0.1,
	amplitude = 1,
	frequency = 2.5,
	updateAmount = 0,
	updating = true,
}

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local Terrain = workspace:WaitForChild("Terrain")

local wsShared = ReplicatedStorage:WaitForChild("WeatherSystem_Shared")
local modules = wsShared:WaitForChild("Modules")
local dynamicWeatherShared = require(modules:WaitForChild("dynamicWeatherShared"))
local configuration = wsShared:WaitForChild("Configuration")
local data = wsShared:WaitForChild("Data")

local isDebug = configuration:GetAttribute("debug")
local print = function(...)
	if isDebug then
		print(`[RTWS Client]: `, ...)
	end
end
-- local warn = function(...)
-- 	if isDebug then
-- 		warn(`[RTWS Client]: `, ...)
-- 	end
-- end

function dynamicWeather:_adjustValues()
	local values = dynamicWeatherShared:getValues()
	self.amplitude = values.amplitude
	self.persistence = values.persistence
	self.lacunarity = values.lacunarity
	self.octaves = values.octaves

	if self.updateAmount > 500 and self.updating == false then
		self.updating = true
		self.updateAmount = 0
	elseif self.updating == false then
		self.updateAmount += 1
	end
end

function dynamicWeather:_loop(deltaTime: number)
	self.lastAnimateOffset = self.serverLastAnimateOffset
	self.animateOffset = self.serverAnimateOffset

	local chunk = Vector2.new(
		math.floor((self.rootPart.Position.X + 32000) / 640),
		math.floor((self.rootPart.Position.Z + 32000) / 640)
	)
	if chunk.X > 101 or chunk.Y > 101 or chunk.X < 1 or chunk.Y < 1 then
		return
	end

	if
		(self.lastAnimateOffset - self.animateOffset).Magnitude > 1
		or self.updating == true
		or self.currentChunk ~= chunk
	then
		self.currentChunk = chunk

		local elevation = dynamicWeatherShared:calculateElevationAtChunk(
			chunk,
			self.frequency,
			self.amplitude,
			self.octaves,
			self.persistence,
			self.lacunarity,
			self.randomSeed,
			self.animateOffset
		)

		self.cloudIntensity = math.clamp((-3 * (elevation ^ 2)) + 1, 0, 1)
		self.precipIntensity = math.clamp((-3 * elevation) + 1, 0, 1)

		-- According to the national snow and ice data center
		-- the general rule is snow can't form above 5 degrees celsius
		-- ground temperature, which is what we're using here
		if data.temperature.Value <= 4.5 and self.rainHandler.rainMode == "rain" then
			self.rainMode = "snow"
			self.rainHandler:setSnow()
		elseif data.temperature.Value > 4.5 and self.rainHandler.rainMode == "snow" then
			self.rainMode = "rain"
			self.rainHandler:setRain()
		end

		self.updating = false
	end

	if self.currentCloudIntensity ~= self.cloudIntensity then
		self.currentCloudIntensity = self.currentCloudIntensity
			+ ((self.cloudIntensity - self.currentCloudIntensity) * deltaTime * 2)
		self.clouds.Cover = self.currentCloudIntensity
		self.clouds.Density = self.currentCloudIntensity * 0.86
	end

	if self.currentPrecipIntensity ~= self.precipIntensity then
		self.currentPrecipIntensity = self.currentPrecipIntensity
			+ ((self.precipIntensity - self.currentPrecipIntensity) * deltaTime * 2)
		self.rainHandler:setIntensity(self.currentPrecipIntensity)

		if self.currentPrecipIntensity > 0.02 and self.rainHandler.rainEnabled == false then
			print("Enabled Rain")
			self.rainHandler:enable()
		end
	end

	if self.currentPrecipIntensity < 0.02 and self.rainHandler.rainEnabled == true then
		self.rainHandler:disable()
		print("Disabled Rain")
	end
end

function dynamicWeather:_adjustAnimation(lastAnimateOffset: Vector2, animateOffset: Vector2)
	self.serverLastAnimateOffset = lastAnimateOffset
	self.serverAnimateOffset = animateOffset
end

function dynamicWeather:start()
	print("Initializing Dynamic Weather")
	self.mapSize = configuration:GetAttribute("MapSize")
	self.mapSizeMin = Vector2.new((100 - self.mapSize.X) / 2 + 1, (100 - self.mapSize.Y) / 2 + 1)
	self.mapSizeMax = Vector2.new((100 + self.mapSize.X) / 2 + 1, (100 + self.mapSize.Y) / 2 + 1)
	self.currentVector = Vector2.new(self.mapSizeMin.X, self.mapSizeMin.Y)
	local lastAnimateOffset: Vector2, animateOffset: Vector2 = self.comm:remoteFunction("getAnimationData")
	self.lastAnimateOffset = lastAnimateOffset
	self.animateOffset = animateOffset
	self.serverLastAnimateOffset = lastAnimateOffset
	self.serverAnimateOffset = animateOffset
	self.currentCloudIntensity = 0
	self.cloudIntensity = 0
	self.currentPrecipIntensity = 0
	self.precipIntensity = 0
	print(self.mapSize, self.mapSizeMin, self.mapSizeMax, self.lastAnimateOffset, self.animateOffset)

	self:_adjustValues()

	local rootPart = nil
	if localPlayer.Character then
		rootPart = localPlayer.Character:WaitForChild("HumanoidRootPart")
		self.rootPart = rootPart
	end

	local clouds = Terrain:FindFirstChildOfClass("Clouds")
	if clouds == nil then
		clouds = Instance.new("Clouds")
		clouds.Parent = Terrain
	end
	self.clouds = clouds

	localPlayer.CharacterAdded:Connect(function(character: Model)
		rootPart = localPlayer.Character:WaitForChild("HumanoidRootPart")
		self.rootPart = rootPart
	end)

	data.pressure:GetPropertyChangedSignal("Value"):Connect(function()
		self:_adjustValues()
	end)
	data.temperature:GetPropertyChangedSignal("Value"):Connect(function()
		self:_adjustValues()
	end)
	data.humidity:GetPropertyChangedSignal("Value"):Connect(function()
		self:_adjustValues()
	end)
	data.intensity:GetPropertyChangedSignal("Value"):Connect(function()
		self:_adjustValues()
	end)
	data.precipChance:GetPropertyChangedSignal("Value"):Connect(function()
		self:_adjustValues()
	end)

	self.events.noiseAnimation:connect(function(lastAnimateOffset: Vector2, animateOffset: Vector2)
		self:_adjustAnimation(lastAnimateOffset, animateOffset)
	end)

	RunService:BindToRenderStep("DynamicWeather", Enum.RenderPriority.Last.Value, function(deltaTime)
		if rootPart == nil or clouds == nil then
			return
		end
		self:_loop(deltaTime)
	end)

	local cloudConnection: RBXScriptConnection? = nil
	local function onCloudsChanged()
		if clouds.Parent == nil then
			print("Clouds got destroyed, recreating")
			clouds = Instance.new("Clouds")
			clouds.Parent = Terrain
			self.clouds = clouds

			if cloudConnection then
				cloudConnection:Disconnect()
			end

			cloudConnection = clouds:GetPropertyChangedSignal("Parent"):Connect(onCloudsChanged)
		end
	end
	cloudConnection = clouds:GetPropertyChangedSignal("Parent"):Connect(onCloudsChanged)

	print("Dynamic Weather Initialized")
end

return dynamicWeather
