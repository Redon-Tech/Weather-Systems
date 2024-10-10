local ReplicatedStorage = game:GetService("ReplicatedStorage")

local wsShared = ReplicatedStorage:WaitForChild("WeatherSystem_Shared")
local configuration = wsShared:WaitForChild("Configuration")
local data = wsShared:WaitForChild("Data")
local globalData = require(wsShared:WaitForChild("globalData"))
local modules = wsShared:WaitForChild("Modules")
local zForecaster = require(modules:WaitForChild("zForecaster"))(
	1, -- TODO: add hemisphere to configuration
	configuration:GetAttribute("HighestPressure"),
	configuration:GetAttribute("LowestPressure")
)
local utils = require(modules:WaitForChild("utils"))
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

local dataHandler = {
	started = false,
} :: types.dataHandler

function dataHandler._calculateNextPressure(self: types.dataHandler, trend: number?)
	local pressure = self.currentClimateData:GetAttribute("Pressure") :: number
	if trend == -1 then
		local min, max = pressure - 5, pressure
		return self.seed:NextInteger(min * 1000, max * 1000) / 1000
	elseif trend == 1 then
		local min, max = pressure, pressure + 5
		return self.seed:NextInteger(min * 1000, max * 1000) / 1000
	else
		local min, max = pressure - 5, pressure + 5
		return self.seed:NextInteger(min * 1000, max * 1000) / 1000
	end
end

function dataHandler._calculateNextTemperature(self: types.dataHandler, getCurrent: boolean?)
	if getCurrent == true then
		if self.isNight == true then
			local averageHigh = self.currentClimateData:GetAttribute("Temperature_High") :: number
			local averageLow = self.currentClimateData:GetAttribute("Temperature_Low") :: number
			return math.floor((self.seed:NextInteger(averageHigh - 10, averageHigh - 5) + averageLow) / 2)
		else
			local averageHigh = self.currentClimateData:GetAttribute("Temperature_High") :: number
			local averageLow = self.currentClimateData:GetAttribute("Temperature_Low") :: number
			return math.ceil((self.seed:NextInteger(averageLow + 5, averageLow + 10) + averageHigh) / 2)
		end
	end

	if self.isNight == true then
		local averageHigh = self.currentClimateData:GetAttribute("Temperature_High") :: number
		local averageLow = self.currentClimateData:GetAttribute("Temperature_Low") :: number
		return math.ceil((self.seed:NextInteger(averageLow + 5, averageLow + 10) + averageHigh) / 2)
	else
		local averageHigh = self.currentClimateData:GetAttribute("Temperature_High") :: number
		local averageLow = self.currentClimateData:GetAttribute("Temperature_Low") :: number
		return math.floor((self.seed:NextInteger(averageHigh - 10, averageHigh - 5) + averageLow) / 2)
	end
end

function dataHandler._calculateNextHumidity(self: types.dataHandler, getCurrent: boolean?)
	local humidity = self.currentClimateData:GetAttribute("Humidity") :: number
	if getCurrent == true then
		if self.isNight == true then
			return self.seed:NextInteger(humidity, humidity + 15)
		else
			return self.seed:NextInteger(humidity - 15, humidity)
		end
	end

	if self.isNight == true then
		return self.seed:NextInteger(humidity - 15, humidity)
	else
		return self.seed:NextInteger(humidity, humidity + 15)
	end
end

function dataHandler.getPressureTrend(self: types.dataHandler)
	local pressure = data.pressure.Value
	local goalPressure = data.pressure:GetAttribute("goal")
	if pressure < goalPressure then
		return 1
	elseif pressure > goalPressure then
		return -1
	else
		return 0
	end
end

function dataHandler._calculateNextWind(self: types.dataHandler)
	local currentWind = Vector2.new(workspace.GlobalWind.X, workspace.GlobalWind.Z)
	local currentWindSpeed = currentWind.Magnitude
	local currentWindDirection = currentWind.Unit
	local newWindDirection = Vector2.new(
		currentWindDirection.X + self.seed:NextNumber(-1, 1),
		currentWindDirection.Y + self.seed:NextNumber(-1, 1)
	)
	local newWindSpeed = math.clamp(self.seed:NextNumber(currentWindSpeed - 5, currentWindSpeed + 5), -10, 10)
	print(newWindDirection.Unit * newWindSpeed)

	return Vector3.new(newWindDirection.X, 0, newWindDirection.Y).Unit * newWindSpeed
end

function dataHandler._calculateNextPrecipData(
	self: types.dataHandler,
	pressure: number,
	pressureTrend: number,
	newWind: Vector3
)
	local windDirection = Vector2.new(newWind.X, newWind.Z)
	local zForecast = zForecaster(pressure, utils.getWindDirection(windDirection), pressureTrend)
	if zForecast == nil then
		return { chance = 1, intensity = 1, value = 32 }
	end

	print(zForecast, globalData.conditionData.names[zForecast])
	local precipData = globalData.conditionData.precipIntensityAndChance[zForecast]
	if precipData == nil then
		return { chance = 1, intensity = 1, value = 32 }
	end

	precipData.intensity = 1 - precipData.intensity
	precipData.chance = 1 - precipData.chance
	precipData.value = zForecast
	return precipData
end

function dataHandler._nextData(
	self: types.dataHandler,
	startingPressure: number,
	startingTemperature: number,
	startingHumidity: number,
	pressureTrend: number,
	startingPrecipData: typeof(globalData.conditionData.precipIntensityAndChance[1]) & { value: number }
)
	-- Pressure
	local goalPressure = self:_calculateNextPressure(pressureTrend)
	data.pressure.Value = startingPressure
	self.startingPressure = startingPressure
	self.goalPressure = goalPressure
	data.pressure:SetAttribute("start", startingPressure)
	data.pressure:SetAttribute("goal", goalPressure)

	-- Temperature
	local goalTemperature = self:_calculateNextTemperature()
	data.temperature.Value = startingTemperature
	self.startingTemperature = startingTemperature
	self.goalTemperature = goalTemperature
	data.temperature:SetAttribute("start", startingTemperature)
	data.temperature:SetAttribute("goal", goalTemperature)

	-- Humidity
	local goalHumidity = self:_calculateNextHumidity()
	data.humidity.Value = startingHumidity
	self.startingHumidity = startingHumidity
	self.goalHumidity = goalHumidity
	data.humidity:SetAttribute("start", startingHumidity)
	data.humidity:SetAttribute("goal", goalHumidity)

	-- Wind
	local goalWind = self:_calculateNextWind()
	self.startingWind = workspace.GlobalWind
	self.goalWind = goalWind

	-- Precipitation
	local goalPrecipData = self:_calculateNextPrecipData(goalPressure, pressureTrend, self.goalWind)
	data.precipChance.Value = startingPrecipData.chance
	self.startingPrecipChance = startingPrecipData.chance
	self.goalPrecipChance = goalPrecipData.chance
	data.intensity.Value = startingPrecipData.intensity
	self.startingPrecipIntensity = startingPrecipData.intensity
	self.goalPrecipIntensity = goalPrecipData.intensity
	data.zForecast.Value = goalPrecipData.value
	self.currentzForecast = goalPrecipData.value
	data.precipChance:SetAttribute("start", startingPrecipData.chance)
	data.intensity:SetAttribute("start", startingPrecipData.intensity)
	data.precipChance:SetAttribute("goal", goalPrecipData.chance)
	data.intensity:SetAttribute("goal", goalPrecipData.intensity)

	print(
		"\n---/ Loop Data \\---",
		"\nPressure:",
		startingPressure,
		goalPressure,
		pressureTrend,
		"\nTemperature:",
		startingTemperature,
		goalTemperature,
		"\nHumidity:",
		startingHumidity,
		goalHumidity,
		"\nPrecipitation:",
		startingPrecipData.chance,
		startingPrecipData.intensity,
		goalPrecipData.chance,
		goalPrecipData.intensity,
		"\n---\\ Loop Data /---"
	)
end

function dataHandler.heartbeat(self: types.dataHandler, deltaTime: number)
	if self.started == false then
		return
	end

	local currentTime = (self.daylight.percentageElapsed * 2) % 1

	data.pressure.Value = utils.lerp(self.startingPressure, self.goalPressure, currentTime)
	data.temperature.Value = utils.lerp(self.startingTemperature, self.goalTemperature, currentTime)
	data.humidity.Value = utils.lerp(self.startingHumidity, self.goalHumidity, currentTime)
	workspace.GlobalWind = utils.lerpVector3(self.startingWind, self.goalWind, currentTime)
	data.precipChance.Value = utils.lerp(self.startingPrecipChance, self.goalPrecipChance, currentTime)
	data.intensity.Value = utils.lerp(self.startingPrecipIntensity, self.goalPrecipIntensity, currentTime)

	if self.currentDataIsDayToNight == false and self.daylight.isPastHalf == true then
		self.currentDataIsDayToNight = true
		self:_nextData(
			self.goalPressure,
			self.goalTemperature,
			self.goalHumidity,
			dataHandler:getPressureTrend(),
			{ chance = self.goalPrecipChance, intensity = self.goalPrecipIntensity, value = self.currentzForecast }
		)
	elseif self.currentDataIsDayToNight == true and self.daylight.isPastHalf == false then
		self.currentDataIsDayToNight = false
		self:_nextData(
			self.goalPressure,
			self.goalTemperature,
			self.goalHumidity,
			self.seed:NextInteger(-1, 1), -- We generate a new pressure trend every day
			{ chance = self.goalPrecipChance, intensity = self.goalPrecipIntensity, value = self.currentzForecast }
		)
	end
end

function dataHandler.start(self: types.dataHandler)
	print("Data Handler initializing")
	local pressureTrend = self.seed:NextInteger(-1, 1)
	local startingPressure = dataHandler:_calculateNextPressure(pressureTrend)
	local startingTemperature = dataHandler:_calculateNextTemperature(true)
	local startingHumidity = dataHandler:_calculateNextHumidity(true)
	workspace.GlobalWind =
		Vector3.new(math.clamp(self.seed:NextNumber(), -10, 10), 0, math.clamp(self.seed:NextNumber(), -10, 10))
	local startingPrecipData =
		dataHandler:_calculateNextPrecipData(startingPressure, pressureTrend, workspace.GlobalWind)
	self.currentDataIsDayToNight = false

	self:_nextData(startingPressure, startingTemperature, startingHumidity, pressureTrend, startingPrecipData)

	self.started = true

	print("Data Handler initialized")
end

return dataHandler
