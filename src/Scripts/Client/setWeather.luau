local ReplicatedStorage = game:GetService("ReplicatedStorage")

local wsShared = ReplicatedStorage:WaitForChild("WeatherSystem_Shared")
local configuration = wsShared:WaitForChild("Configuration")
local data = wsShared:WaitForChild("Data")
local globalData = require(wsShared:WaitForChild("globalData"))
local types = require(script.Parent:WaitForChild("types"))

local isDebug = configuration:GetAttribute("debug")
local print = function(...)
	if isDebug then
		print(`[RTWS Client]: `, ...)
	end
end

local setWeather = {} :: types.setWeather

function setWeather.weatherChanged(self: types.setWeather)
	if self.enabled == false then
		return
	end

	local weather: globalData.weatherTypes = data.setWeather.Value
	local cloudCover = data.cloudCover.Value
	if cloudCover ~= 0 then
		cloudCover /= 100
	end

	if self.cloudServerControlled == true then
		self.rainHandler:setCloud(cloudCover, cloudCover)
	end

	if weather == "Clear" then
		self.rainHandler:disable()
		if self.cloudServerControlled == false then
			self.rainHandler:setCloud(0, 0)
		end
	elseif weather == "Partly Cloudy" then
		self.rainHandler:disable()
		if self.cloudServerControlled == false then
			self.rainHandler:setCloud(0.5, 0.4)
		end
	elseif weather == "Mostly Cloudy" then
		self.rainHandler:disable()
		if self.cloudServerControlled == false then
			self.rainHandler:setCloud(0.65, 0.6)
		end
	elseif weather == "Cloudy" then
		self.rainHandler:disable()
		if self.cloudServerControlled == false then
			self.rainHandler:setCloud(0.8, 0.8)
		end
	elseif weather == "Drizzle" then
		self.rainHandler:enable()
		self.rainHandler:setIntensity(0.05)
		if self.cloudServerControlled == false then
			self.rainHandler:setCloud(0.8, 1)
		end
	elseif weather == "Showers" then
		self.rainHandler:enable()
		self.rainHandler:setIntensity(0.3)
		if self.cloudServerControlled == false then
			self.rainHandler:setCloud(0.82, 1)
		end
	elseif weather == "Rain" then
		self.rainHandler:enable()
		self.rainHandler:setIntensity(0.5)
		if self.cloudServerControlled == false then
			self.rainHandler:setCloud(0.9, 1)
		end
	elseif weather == "Heavy Rain" then
		self.rainHandler:enable()
		self.rainHandler:setIntensity(0.5)
		if self.cloudServerControlled == false then
			self.rainHandler:setCloud(0.9, 1)
		end
	elseif weather == "Thunderstorms" then
		self.rainHandler:enable()
		self.rainHandler:setIntensity(0.7)
		if self.cloudServerControlled == false then
			self.rainHandler:setCloud(0.95, 1)
		end
	elseif weather == "Strong Thunderstorms" then
		self.rainHandler:enable()
		self.rainHandler:setIntensity(1)
		if self.cloudServerControlled == false then
			self.rainHandler:setCloud(1, 1)
		end
	end

	if data.temperature.Value < 4.5 then
		self.rainHandler:setSnow()
	else
		self.rainHandler:setRain()
	end
end

function setWeather.start(self: types.setWeather)
	local function onWeatherChanged()
		if configuration.weather:GetAttribute("WeatherMode") ~= "dynamic" then
			self.enabled = true

			if configuration.weather:GetAttribute("WeatherMode") == "realTime" then
				self.cloudServerControlled = true
			else
				self.cloudServerControlled = false
			end
		else
			self.enabled = false
		end
	end
	onWeatherChanged()
	configuration.weather:GetAttributeChangedSignal("WeatherMode"):Connect(onWeatherChanged)

	self:weatherChanged()
	data.setWeather:GetPropertyChangedSignal("Value"):Connect(function()
		self:weatherChanged()
	end)

	data.temperature:GetPropertyChangedSignal("Value"):Connect(function()
		self:weatherChanged()
	end)

	data.cloudCover:GetPropertyChangedSignal("Value"):Connect(function()
		self:weatherChanged()
	end)
end

return setWeather
