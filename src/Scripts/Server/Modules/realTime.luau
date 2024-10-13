local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local wsShared = ReplicatedStorage:WaitForChild("WeatherSystem_Shared")
local modules = wsShared:WaitForChild("Modules")
local EvLightning = require(modules:WaitForChild("EvLightning"))
local configuration = wsShared:WaitForChild("Configuration")
local data = wsShared:WaitForChild("Data")
local globalData = require(wsShared:WaitForChild("globalData"))
local types = require(script.Parent.Parent.types)

local isDebug = configuration:GetAttribute("debug")
local print = function(...)
	if isDebug then
		print(`[RTWS Client]: `, ...)
	end
end

local realTime = {
	task = false,
} :: types.realTime

-- local angle = math.rad(314)
-- local speed = (3.75*3.57)
-- local vector = Vector3.new(math.cos(angle), 0, math.sin(angle))
-- print(vector*speed, speed)

function realTime.startLoop(self: types.realTime)
	task.spawn(function()
		local latitude = configuration.weather:GetAttribute("Latitude")
		local longitude = configuration.weather:GetAttribute("Longitude")
		if not latitude or not longitude then
			warn("Latitude and longitude not set, realtime weather will not work. Falling back to zWeather.")
			configuration.weather:SetAttribute("WeatherMode", "zWeather")
			return
		end

		repeat
			local response = HttpService:RequestAsync({
				Url = `https://api.open-meteo.com/v1/forecast?latitude={latitude}&longitude={longitude}&current=temperature_2m,relative_humidity_2m,weather_code,cloud_cover,pressure_msl,wind_speed_10m,wind_direction_10m&wind_speed_unit=ms`,
				Method = "GET",
			})
			if response.Success == true then
				local responseData = HttpService:JSONDecode(response.Body)
				local weatherCode = responseData.current.weather_code
				local windSpeed = responseData.current.wind_speed_10m
				local windDirection = responseData.current.wind_direction_10m
				local temperature = responseData.current.temperature_2m
				local humidity = responseData.current.relative_humidity_2m
				local pressure = responseData.current.pressure_msl
				local cloudCover = responseData.current.cloud_cover
				print(weatherCode, windSpeed, windDirection, temperature, humidity, pressure, cloudCover)

				local setWeather: globalData.weatherTypes = globalData.wmoWeatherCodes[weatherCode]
				if setWeather then
					data.setWeather.Value = setWeather

					if setWeather == "Thunderstorms" or setWeather == "Strong Thunderstorms" then
						local chance = if setWeather == "Thunderstorms" then 20 else 50
						self.task = task.spawn(function()
							while task.wait(math.random(1, 10)) do
								local random = math.random(0, 100)
								print(random, chance)
								if random < chance then
									local randomPosition = Vector3.new(
										math.random(
											(self.dynamicWeather.mapSizeMin.X - 50) * 640,
											(self.dynamicWeather.mapSizeMax.X - 50) * 640
										),
										400,
										math.random(
											(self.dynamicWeather.mapSizeMin.Y - 50) * 640,
											(self.dynamicWeather.mapSizeMax.Y - 50) * 640
										)
									)
									local bolt = EvLightning.new(
										randomPosition,
										randomPosition - Vector3.new(0, 400, 0),
										{ decay = 0.15, tween_time = 0.15 }
									)
									bolt:Draw()
								end
							end
						end)
					elseif self.task ~= false then
						task.cancel(self.task)
						self.task = false
					end
				else
					warn("Unknown weather code: ", weatherCode)
				end

				local windVector = Vector3.new(math.cos(math.rad(windDirection)), 0, math.sin(math.rad(windDirection)))
				local correctedWindSpeed = windSpeed * 3.57
				workspace.GlobalWind = windVector * correctedWindSpeed

				data.temperature.Value = temperature
				data.humidity.Value = humidity
				data.pressure.Value = pressure
				data.cloudCover.Value = cloudCover

				local interval = responseData.current.interval
				local currentDataTime = responseData.current.time
				local nextDataTime = DateTime.fromIsoDate(currentDataTime).UnixTimestamp + interval
				print(currentDataTime, interval, nextDataTime, nextDataTime - DateTime.now().UnixTimestamp)
				task.wait(nextDataTime - DateTime.now().UnixTimestamp)
			else
				warn(
					"Failed to get realtime weather data, falling back to zWeather.",
					response.StatusMessage,
					response.Body
				)
				configuration.weather:SetAttribute("WeatherMode", "zWeather")
				return
			end
		until self.enabled == false
	end)
end

function realTime.start(self: types.realTime)
	local function onWeatherChanged()
		if configuration.weather:GetAttribute("WeatherMode") == "realTime" then
			if HttpService.HttpEnabled == false then
				warn("HttpService is disabled, realtime weather will not work. Falling back to zWeather.")
				configuration.weather:SetAttribute("WeatherMode", "zWeather")
				return
			end

			self.enabled = true

			self:startLoop()
		else
			self.enabled = false

			if self.task ~= false then
				task.cancel(self.task)
				self.task = false
			end
		end
	end
	onWeatherChanged()
	configuration.weather:GetAttributeChangedSignal("WeatherMode"):Connect(onWeatherChanged)
end

return realTime
