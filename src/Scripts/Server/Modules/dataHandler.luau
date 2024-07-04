local dataHandler = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Shared = ReplicatedStorage:WaitForChild("WeatherSystem_Shared")
local Configuration = Shared:WaitForChild("Configuration")
local Data = Shared:WaitForChild("Data")

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
			return self.seed:NextInteger(
				self.currentClimateData:GetAttribute("Temperature_Low") - 5,
				self.currentClimateData:GetAttribute("Temperature_Low") + 5
			)
		else
			return self.seed:NextInteger(
				self.currentClimateData:GetAttribute("Temperature_High") - 5,
				self.currentClimateData:GetAttribute("Temperature_High") + 5
			)
		end
	end

	if self.isNight == true then
		return self.seed:NextInteger(
			self.currentClimateData:GetAttribute("Temperature_High") - 5,
			self.currentClimateData:GetAttribute("Temperature_High") + 5
		)
	else
		return self.seed:NextInteger(
			self.currentClimateData:GetAttribute("Temperature_Low") - 5,
			self.currentClimateData:GetAttribute("Temperature_Low") + 5
		)
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

function dataHandler:_startLoop(
	startingPressure: number,
	startingTemperature: number,
	startingHumidity: number,
	pressureTrend: number?
)
	local goalPressure = self:_calculateNextPressure(pressureTrend)
	Data.pressure.Value = startingPressure
	local goalTemperature = self:_calculateNextTemperature()
	Data.temperature.Value = startingTemperature
	local goalHumidity = self:_calculateNextHumidity()
	Data.humidity.Value = startingHumidity

	print(
		"---/ Loop Data \\---",
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
		"\n---\\ Loop Data /---"
	)
	local tween = TweenService:Create(
		Data.pressure,
		TweenInfo.new(self.daylight.dayLength / 2, Enum.EasingStyle.Linear),
		{ Value = goalPressure }
	)
	local tween2 = TweenService:Create(
		Data.temperature,
		TweenInfo.new(self.daylight.dayLength / 2, Enum.EasingStyle.Linear),
		{ Value = goalTemperature }
	)
	tween:Play()
	tween2:Play()
	tween.Completed:Wait()

	pressureTrend = self.seed:NextInteger(-1, 1)
	self:_startLoop(goalPressure, goalTemperature, goalHumidity, pressureTrend)
end

function dataHandler:start()
	print("Data Handler initializing")
	local startingPressure = dataHandler:_calculateNextPressure()
	local startingTemperature = dataHandler:_calculateNextTemperature(true)
	local startingHumidity = dataHandler:_calculateNextHumidity(true)
	local pressureTrend = self.seed:NextInteger(-1, 1)

	task.spawn(function()
		print("Data Handler starting loop")
		self:_startLoop(startingPressure, startingTemperature, startingHumidity, pressureTrend)
	end)

	print("Data Handler initialized")
end

return dataHandler
