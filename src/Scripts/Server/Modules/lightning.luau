local ReplicatedStorage = game:GetService("ReplicatedStorage")

local wsShared = ReplicatedStorage:WaitForChild("WeatherSystem_Shared")
local modules = wsShared:WaitForChild("Modules")
local EvLightning = require(modules:WaitForChild("EvLightning"))
local configuration = wsShared:WaitForChild("Configuration")
local data = wsShared:WaitForChild("Data")
local types = require(script.Parent.Parent.types)

local isDebug = configuration:GetAttribute("debug")
local print = function(...)
	if isDebug then
		print(`[RTWS Client]: `, ...)
	end
end

local lightning = {
	task = false,
} :: types.lightning

function lightning.castLightning(self: types.lightning, position: Vector3)
	local bolt = EvLightning.new(
		position + Vector3.new(0, 600, 0),
		position,
		{ decay = 0.15, tween_time = 0.15, bends = math.random(4, 8) }
	)
	bolt:Draw()
end

function lightning.weatherChanged(self: types.lightning)
	if self.enabled == false then
		return
	end

	local setWeather = data.setWeather.Value

	if setWeather == "Thunderstorms" or setWeather == "Strong Thunderstorms" then
		local chance = if setWeather == "Thunderstorms" then 20 else 50
		self.task = task.spawn(function()
			while task.wait(math.random(1, 10)) do
				local random = math.random(0, 100)
				print(random, chance)
				if random < chance and data.temperature.Value > 4.5 then
					local randomPosition = Vector3.new(
						math.random(
							(self.dynamicWeather.mapSizeMin.X - 50) * 640,
							(self.dynamicWeather.mapSizeMax.X - 50) * 640
						),
						0,
						math.random(
							(self.dynamicWeather.mapSizeMin.Y - 50) * 640,
							(self.dynamicWeather.mapSizeMax.Y - 50) * 640
						)
					)
					randomPosition = Vector3.zero
					self:castLightning(randomPosition)
				end
			end
		end)
	elseif self.task ~= false then
		task.cancel(self.task)
		self.task = false
	end
end

function lightning.start(self: types.lightning)
	local function onWeatherChanged()
		if configuration.weather:GetAttribute("WeatherMode") == "dynamic" then
			self.enabled = false

			if self.task ~= false then
				task.cancel(self.task)
				self.task = false
			end
		else
			self.enabled = true

			self:weatherChanged()
		end
	end
	onWeatherChanged()
	configuration.weather:GetAttributeChangedSignal("WeatherMode"):Connect(onWeatherChanged)

	data.setWeather:GetPropertyChangedSignal("Value"):Connect(function()
		self:weatherChanged()
	end)
end

return lightning
