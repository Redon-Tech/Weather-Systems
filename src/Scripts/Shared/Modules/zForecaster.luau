--Zambretti Algorhithm
--Based off of https://github.com/sassoftware/iot-zambretti-weather-forcasting/ and http://www.beteljuice.co.uk/zambretti/forecast.html

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("WeatherSystem_Shared")
-- local globalData = require(Shared:WaitForChild("globalData"))
-- local Configuration = Shared:WaitForChild("Configuration")
local Data = Shared:WaitForChild("Data")

return function(hemisphere, upper, lower)
	hemisphere = hemisphere or 1
	upper = upper or 1030
	lower = lower or 1010
	local range = upper - lower
	local constant = range / 22

	return function(pressure, wind, trend)
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

			if Data.season.Value == "Summer" then
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

			if Data.season.Value == "Winter" then
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

		return math.floor((pressure - lower) / constant), pressure
	end
end
