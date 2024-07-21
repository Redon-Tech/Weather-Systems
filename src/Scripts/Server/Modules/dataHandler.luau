local dataHandler = {
	started = false,
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("WeatherSystem_Shared")
local Configuration = Shared:WaitForChild("Configuration")
local Data = Shared:WaitForChild("Data")
local GlobalData = require(Shared:WaitForChild("globalData"))
local Modules = Shared:WaitForChild("Modules")
local zForecaster = require(Modules:WaitForChild("zForecaster"))(
	1, -- TODO: add hemisphere to configuration
	Configuration:GetAttribute("HighestPressure"),
	Configuration:GetAttribute("LowestPressure")
)
local utils = require(Modules:WaitForChild("utils"))

local isDebug = Configuration:GetAttribute("debug")
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

function dataHandler:_calculateNextPressure(trend: number?)
	if trend == -1 then
		local min, max =
			self.currentClimateData:GetAttribute("Pressure") - 5, self.currentClimateData:GetAttribute("Pressure")
		return self.seed:NextInteger(min * 1000, max * 1000) / 1000
	elseif trend == 1 then
		local min, max =
			self.currentClimateData:GetAttribute("Pressure"), self.currentClimateData:GetAttribute("Pressure") + 5
		return self.seed:NextInteger(min * 1000, max * 1000) / 1000
	else
		local min, max =
			self.currentClimateData:GetAttribute("Pressure") - 5, self.currentClimateData:GetAttribute("Pressure") + 5
		return self.seed:NextInteger(min * 1000, max * 1000) / 1000
	end
end

function dataHandler:_calculateNextTemperature(getCurrent: boolean?)
	if getCurrent == true then
		if self.isNight == true then
			local averageHigh = self.currentClimateData:GetAttribute("Temperature_High")
			local averageLow = self.currentClimateData:GetAttribute("Temperature_Low")
			return math.floor((self.seed:NextInteger(averageHigh - 10, averageHigh - 5) + averageLow) / 2)
		else
			local averageHigh = self.currentClimateData:GetAttribute("Temperature_High")
			local averageLow = self.currentClimateData:GetAttribute("Temperature_Low")
			return math.ceil((self.seed:NextInteger(averageLow + 5, averageLow + 10) + averageHigh) / 2)
		end
	end

	if self.isNight == true then
		local averageHigh = self.currentClimateData:GetAttribute("Temperature_High")
		local averageLow = self.currentClimateData:GetAttribute("Temperature_Low")
		return math.ceil((self.seed:NextInteger(averageLow + 5, averageLow + 10) + averageHigh) / 2)
	else
		local averageHigh = self.currentClimateData:GetAttribute("Temperature_High")
		local averageLow = self.currentClimateData:GetAttribute("Temperature_Low")
		return math.floor((self.seed:NextInteger(averageHigh - 10, averageHigh - 5) + averageLow) / 2)
	end
end

function dataHandler:_calculateNextHumidity(getCurrent: boolean?)
	if getCurrent == true then
		if self.isNight == true then
			return self.seed:NextInteger(
				self.currentClimateData:GetAttribute("Humidity"),
				self.currentClimateData:GetAttribute("Humidity") + 15
			)
		else
			return self.seed:NextInteger(
				self.currentClimateData:GetAttribute("Humidity") - 15,
				self.currentClimateData:GetAttribute("Humidity")
			)
		end
	end

	if self.isNight == true then
		return self.seed:NextInteger(
			self.currentClimateData:GetAttribute("Humidity") - 15,
			self.currentClimateData:GetAttribute("Humidity")
		)
	else
		return self.seed:NextInteger(
			self.currentClimateData:GetAttribute("Humidity"),
			self.currentClimateData:GetAttribute("Humidity") + 15
		)
	end
end

function dataHandler:getPressureTrend()
	local pressure = Data.pressure.Value
	local goalPressure = Data.pressure:GetAttribute("goal")
	if pressure < goalPressure then
		return 1
	elseif pressure > goalPressure then
		return -1
	else
		return 0
	end
end

function dataHandler:_calculateNextPrecipData(
	pressure: number,
	pressureTrend: number
): { chance: number, intensity: number }
	local windDirection = Vector2.new(workspace.GlobalWind.X, workspace.GlobalWind.Z)
	local zForecast = zForecaster(pressure, utils.getWindDirection(windDirection), pressureTrend)
	if zForecast == nil then
		return { chance = 1, intensity = 1 }
	end

	print(zForecast, GlobalData.conditionData.names[zForecast])
	local precipData = GlobalData.conditionData.precipIntensityAndChance[zForecast]
	if precipData == nil then
		return { chance = 1, intensity = 1 }
	end

	precipData.intensity = 1 - precipData.intensity
	precipData.chance = 1 - precipData.chance
	return precipData
end

function dataHandler:_nextData(
	startingPressure: number,
	startingTemperature: number,
	startingHumidity: number,
	pressureTrend: number,
	startingPrecipData: { chance: number, intensity: number }
)
	local goalPressure = self:_calculateNextPressure(pressureTrend)
	Data.pressure.Value = startingPressure
	self.startingPressure = startingPressure
	self.goalPressure = goalPressure
	Data.pressure:SetAttribute("start", startingPressure)
	Data.pressure:SetAttribute("goal", goalPressure)
	local goalTemperature = self:_calculateNextTemperature()
	Data.temperature.Value = startingTemperature
	self.startingTemperature = startingTemperature
	self.goalTemperature = goalTemperature
	Data.temperature:SetAttribute("start", startingTemperature)
	Data.temperature:SetAttribute("goal", goalTemperature)
	local goalHumidity = self:_calculateNextHumidity()
	Data.humidity.Value = startingHumidity
	self.startingHumidity = startingHumidity
	self.goalHumidity = goalHumidity
	Data.humidity:SetAttribute("start", startingHumidity)
	Data.humidity:SetAttribute("goal", goalHumidity)
	local goalPrecipData = self:_calculateNextPrecipData(goalPressure, pressureTrend)
	Data.precipChance.Value = startingPrecipData.chance
	self.startingPrecipChance = startingPrecipData.chance
	self.goalPrecipChance = goalPrecipData.chance
	Data.intensity.Value = startingPrecipData.intensity
	self.startingPrecipIntensity = startingPrecipData.intensity
	self.goalPrecipIntensity = goalPrecipData.intensity
	Data.precipChance:SetAttribute("start", startingPrecipData.chance)
	Data.intensity:SetAttribute("start", startingPrecipData.intensity)
	Data.precipChance:SetAttribute("goal", goalPrecipData.chance)
	Data.intensity:SetAttribute("goal", goalPrecipData.intensity)

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

function dataHandler:heartbeat(deltaTime: number)
	if self.started == false then
		return
	end

	local currentTime = (self.daylight.percentageElapsed * 2) % 1

	Data.pressure.Value = utils.lerp(self.startingPressure, self.goalPressure, currentTime)
	Data.temperature.Value = utils.lerp(self.startingTemperature, self.goalTemperature, currentTime)
	Data.humidity.Value = utils.lerp(self.startingHumidity, self.goalHumidity, currentTime)
	Data.precipChance.Value = utils.lerp(self.startingPrecipChance, self.goalPrecipChance, currentTime)
	Data.intensity.Value = utils.lerp(self.startingPrecipIntensity, self.goalPrecipIntensity, currentTime)

	if self.currentDataIsDayToNight == false and self.daylight.isPastHalf == true then
		self.currentDataIsDayToNight = true
		self:_nextData(
			self.goalPressure,
			self.goalTemperature,
			self.goalHumidity,
			dataHandler:getPressureTrend(),
			{ chance = self.goalPrecipChance, intensity = self.goalPrecipIntensity }
		)
	elseif self.currentDataIsDayToNight == true and self.daylight.isPastHalf == false then
		self.currentDataIsDayToNight = false
		self:_nextData(
			self.goalPressure,
			self.goalTemperature,
			self.goalHumidity,
			self.seed:NextInteger(-1, 1), -- We generate a new pressure trend every day
			{ chance = self.goalPrecipChance, intensity = self.goalPrecipIntensity }
		)
	end
end

function dataHandler:start()
	print("Data Handler initializing")
	local pressureTrend = self.seed:NextInteger(-1, 1)
	local startingPressure = dataHandler:_calculateNextPressure(pressureTrend)
	local startingTemperature = dataHandler:_calculateNextTemperature(true)
	local startingHumidity = dataHandler:_calculateNextHumidity(true)
	local startingPrecipData = dataHandler:_calculateNextPrecipData(startingPressure, pressureTrend)
	self.currentDataIsDayToNight = false

	self:_nextData(startingPressure, startingTemperature, startingHumidity, pressureTrend, startingPrecipData)

	self.started = true

	print("Data Handler initialized")
end

return dataHandler
