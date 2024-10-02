local ReplicatedStorage = game:GetService("ReplicatedStorage")
local wsShared = ReplicatedStorage:WaitForChild("WeatherSystem_Shared")
local configuration = wsShared:WaitForChild("Configuration")
local measurementInfo = configuration:WaitForChild("measurementInfo")
local climateData = configuration:WaitForChild("climateData")
local globalData = require(wsShared:WaitForChild("globalData"))

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

local conversions = {}

function conversions:convertPressure(input: number, from: string)
	if globalData.pressure[from] then
		local equivalentPressure = input * globalData.pressure[from]
		return equivalentPressure, "mbar"
	else
		error("Invalid input unit")
	end
end

function conversions:convertAllMonthData()
	local from = measurementInfo:GetAttribute("PressureMeasurement")

	for _, month: Configuration in pairs(climateData:GetChildren()) do
		month:SetAttribute("Pressure", self:convertPressure(month:GetAttribute("Pressure"), from))
	end
end

function conversions:convertMapSize()
	local mapSizeBefore = configuration:GetAttribute("MapSize")
	local mapSizeAfter = Vector2.new(
		math.clamp(math.ceil(mapSizeBefore.X / 320), 1, 101),
		math.clamp(math.ceil(mapSizeBefore.Y / 320), 1, 101)
	)

	print(mapSizeAfter)
	configuration:SetAttribute("MapSize", mapSizeAfter)
end

return conversions
