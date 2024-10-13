local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

local zWeather = {
	task = false,
} :: types.zWeather

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

	if determinedWeather == "Thunderstorms" or determinedWeather == "Strong Thunderstorms" then
		local chance = if determinedWeather == "Thunderstorms" then 20 else 50
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
end

function zWeather.start(self: types.zWeather)
	local function onWeatherChanged()
		if configuration.weather:GetAttribute("WeatherMode") == "zWeather" then
			self.enabled = true
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

	self:weatherChanged()
	data.zForecast:GetPropertyChangedSignal("Value"):Connect(function()
		self:weatherChanged()
	end)
end

return zWeather
