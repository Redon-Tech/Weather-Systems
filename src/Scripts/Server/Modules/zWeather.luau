local ReplicatedStorage = game:GetService("ReplicatedStorage")

local wsShared = ReplicatedStorage:WaitForChild("WeatherSystem_Shared")
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

local zWeather = {} :: types.zWeather

function zWeather.weatherChanged(self: types.zWeather)
	if self.enabled == false then
		return
	end

	local determinedWeather = globalData.conditionData.weatherDetermined[data.zForecast.Value]
	if determinedWeather == nil then
		determinedWeather = "Clear"
	end
	print(determinedWeather)
	data.setWeather.Value = determinedWeather
end

function zWeather.start(self: types.zWeather)
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
	data.zForecast:GetPropertyChangedSignal("Value"):Connect(function()
		self:weatherChanged()
	end)
end

return zWeather
