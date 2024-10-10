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

	if weather == "Clear" then
		self.rainHandler:disable()
		self.rainHandler:setCloud(0, 0)
	elseif weather == "Partly Cloudy" then
		self.rainHandler:disable()
		self.rainHandler:setCloud(0.5, 0.4)
	elseif weather == "Mostly Cloudy" then
		self.rainHandler:disable()
		self.rainHandler:setCloud(0.65, 0.6)
	elseif weather == "Cloudy" then
		self.rainHandler:disable()
		self.rainHandler:setCloud(0.8, 0.8)
	elseif weather == "Drizzle" then
		self.rainHandler:enable()
		self.rainHandler:setIntensity(0.05)
		self.rainHandler:setCloud(0.8, 1)
	elseif weather == "Showers" then
		self.rainHandler:enable()
		self.rainHandler:setIntensity(0.3)
		self.rainHandler:setCloud(0.82, 1)
	elseif weather == "Rain" then
		self.rainHandler:enable()
		self.rainHandler:setIntensity(0.5)
		self.rainHandler:setCloud(0.9, 1)
	elseif weather == "Thunderstorms" then
		self.rainHandler:enable()
		self.rainHandler:setIntensity(0.7)
		self.rainHandler:setCloud(0.95, 1)
	elseif weather == "Strong Thunderstorms" then
		self.rainHandler:enable()
		self.rainHandler:setIntensity(1)
		self.rainHandler:setCloud(1, 1)
	end

	if data.temperature.Value < 4.5 then
		self.rainHandler:setSnow()
	else
		self.rainHandler:setRain()
	end
end

function setWeather.start(self: types.setWeather)
	local function onWeatherChanged()
		if configuration.weather:GetAttribute("WeatherMode") == "zWeather" then
			self.enabled = true
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
end

return setWeather
