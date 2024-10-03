--Zambretti Algorhithm
--Based off of https://github.com/sassoftware/iot-zambretti-weather-forcasting/ and http://www.beteljuice.co.uk/zambretti/forecast.html

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local wsShared = ReplicatedStorage:WaitForChild("WeatherSystem_Shared")
local data = wsShared:WaitForChild("Data")
local globalData = require(wsShared:WaitForChild("globalData"))

return function(
	hemisphere: number,
	upper: number,
	lower: number
): (pressure: number, wind: string, trend: number) -> number
	hemisphere = hemisphere or 1
	upper = upper or 1030
	lower = lower or 1010
	local range = upper - lower
	local constant = range / 22

	return function(pressure: number, wind: string, trend: number): number
		if hemisphere == 1 then
			if wind == "N" then
				pressure += 0.06 * range
			elseif wind == "NNE" then
				pressure += 0.05 * range
			elseif wind == "NE" then
				pressure += 0.05 * range
			elseif wind == "ENE" then
				pressure += 0.02 * range
			elseif wind == "E" then
				pressure -= 0.005 * range
			elseif wind == "ESE" then
				pressure -= 0.02 * range
			elseif wind == "SE" then
				pressure -= 0.05 * range
			elseif wind == "SSE" then
				pressure -= 0.085 * range
			elseif wind == "S" then
				pressure -= 0.12 * range
			elseif wind == "SSW" then
				pressure -= 0.10 * range
			elseif wind == "SW" then
				pressure -= 0.06 * range
			elseif wind == "WSW" then
				pressure -= 0.045 * range
			elseif wind == "W" then
				pressure -= 0.03 * range
			elseif wind == "WNW" then
				pressure -= 0.005 * range
			elseif wind == "NW" then
				pressure += 0.015 * range
			elseif wind == "NNW" then
				pressure += 0.03 * range
			end

			if data.season.Value == "Summer" then
				if trend == 1 then
					pressure += 0.07 * range
				elseif trend == 2 then
					pressure -= 0.07 * range
				end
			end
		else
			if wind == "S" then
				pressure += 0.06 * range
			elseif wind == "SSW" then
				pressure += 0.05 * range
			elseif wind == "SW" then
				pressure += 0.05 * range
			elseif wind == "WSW" then
				pressure += 0.02 * range
			elseif wind == "W" then
				pressure -= 0.005 * range
			elseif wind == "WNW" then
				pressure -= 0.02 * range
			elseif wind == "NW" then
				pressure -= 0.05 * range
			elseif wind == "NNW" then
				pressure -= 0.085 * range
			elseif wind == "N" then
				pressure -= 0.12 * range
			elseif wind == "NNE" then
				pressure -= 0.10 * range
			elseif wind == "NE" then
				pressure -= 0.06 * range
			elseif wind == "ENE" then
				pressure -= 0.045 * range
			elseif wind == "E" then
				pressure -= 0.03 * range
			elseif wind == "ESE" then
				pressure -= 0.005 * range
			elseif wind == "SE" then
				pressure += 0.015 * range
			elseif wind == "SSE" then
				pressure += 0.03 * range
			end

			if data.season.Value == "Winter" then
				if trend == 1 then
					pressure += 0.07 * range
				elseif trend == 2 then
					pressure -= 0.07 * range
				end
			end
		end

		if pressure == upper then
			pressure = upper - 1
		end

		local value = math.floor((pressure - lower) / constant)
		if trend == 1 then
			return globalData.conditionOptions.rising[value]
		elseif trend == 2 then
			return globalData.conditionOptions.falling[value]
		else
			return globalData.conditionOptions.steady[value]
		end
	end
end
