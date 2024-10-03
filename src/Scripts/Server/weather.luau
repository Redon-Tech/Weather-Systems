local ReplicatedStorage = game:GetService("ReplicatedStorage")

local wsShared = ReplicatedStorage:WaitForChild("WeatherSystem_Shared")
local globalData = require(wsShared:WaitForChild("globalData"))
local configuration = wsShared:WaitForChild("Configuration")
local data = wsShared:WaitForChild("Data")
local dayCycleConfig = configuration:WaitForChild("dayCycle")
local serverModules = script.Parent:WaitForChild("Modules")
local sharedModules = wsShared:WaitForChild("Modules")
local comm = require(sharedModules:WaitForChild("comm"))
local types = require(script.Parent.types)

local isDebug = configuration:GetAttribute("debug")
local truePrint = print
local print = function(...)
	if isDebug then
		print(`[RTWS Server]: `, ...)
	end
end
local warn = function(...)
	if isDebug then
		warn(`[RTWS Server]: `, ...)
	end
end

local weather = {
	modules = {},
} :: types.weather

function weather._newDay(self: types.weather, dayNum: number)
	for i = 1, #globalData.months do
		local data = globalData.months[i]
		if dayNum > data.MinDays and dayNum <= data.MaxDays then
			self.month = {
				Name = data.Name,
				Short = data.Short,
				Number = i,
			}
			break
		end
	end

	if dayNum < 80 or dayNum >= 355 then
		self.season = "Winter"
	elseif dayNum >= 80 and dayNum < 172 then
		self.season = "Spring"
	elseif dayNum >= 172 and dayNum < 264 then
		self.season = "Summer"
	elseif dayNum >= 264 and dayNum < 355 then
		self.season = "Fall"
	else
		print("Season error", dayNum)
	end

	self.day = dayNum - globalData.months[self.month.Number].MinDays
	data.day.Value = self.day
	data.month.Value = self.month.Name
	data.season.Value = self.season
	self.currentClimateData = configuration.climateData:FindFirstChild(self.month.Name)
	self.hasChanged = false

	print(self.day, self.month.Name, self.season)
end

function weather._timeOfDay(self: types.weather)
	local time = game.Lighting:GetMinutesAfterMidnight()

	if time == 0 then
		self.currentDay = self.currentDay + 1
		if self.currentDay > 365 then
			self.currentDay = 1
		end
		self:_newDay(self.currentDay)
	elseif self.hasChanged == false and (time >= 700 and time <= 800) then
		-- TODO: Vx.x: an actual algorithm for moon phases: masive maybe on this
		self.hasChanged = true
		self.currentMoonPhase = self.currentMoonPhase + 1
		if self.currentMoonPhase > 8 then
			self.currentMoonPhase = 1
		end
		self.sky.MoonTextureId = dayCycleConfig
			:FindFirstChild("moonPhases")
			:GetAttribute(tostring(self.currentMoonPhase)) or "rbxasset://sky/moon.jpg"
	elseif
		self.isNight == false
		and (time >= dayCycleConfig:GetAttribute("sunset") or time <= dayCycleConfig:GetAttribute("sunrise"))
	then
		self.isNight = true
		print("Night", self.isNight)
	elseif
		self.isNight == true
		and (time >= dayCycleConfig:GetAttribute("sunrise") and time <= dayCycleConfig:GetAttribute("sunset"))
	then
		self.isNight = false
		print("Day", self.isNight)
	end

	if self.valuesInitialized == false then
		self.valuesInitialized = true
		self:_initValues()
	end
end

function weather._initValues(self: types.weather)
	self.dataHandler:start()

	local lowestPressure = 1000
	local highestPressure = 0
	for _, v in pairs(configuration.climateData:GetChildren()) do
		if v:GetAttribute("Pressure") - 5 < lowestPressure then
			lowestPressure = v:GetAttribute("Pressure") - 5
		end

		if v:GetAttribute("Pressure") + 5 > highestPressure then
			highestPressure = v:GetAttribute("Pressure") + 5
		end
	end
	configuration:SetAttribute("LowestPressure", lowestPressure)
	configuration:SetAttribute("HighestPressure", highestPressure)
end

function weather._initModule(self: types.weather, module: ModuleScript)
	local tbl = require(module)
	assert(type(tbl) == "table", `invalid return from module {module.Name} (table expected, got {type(tbl)})`)
	if table.find(self.modules, module.Name) then
		warn(`module {module.Name} has already been initialized, skipping`)
		return
	end

	self[module.Name] = tbl
	table.insert(self.modules, module.Name)

	local success, err = pcall(function()
		setmetatable(tbl, { __index = weather })
	end)
	assert(success, `failed to set metatable for module {module.Name}: {err}`)
end

function weather.start(self: types.weather)
	truePrint(`Starting Server\n		Version: {configuration:GetAttribute("version")}\n		Debug: {isDebug}`)
	setmetatable(weather, { __index = weather })

	if game.Lighting:FindFirstChild("Sky") then
		self.sky = game.Lighting:FindFirstChild("Sky")
	else
		self.sky = Instance.new("Sky")
		self.sky.Parent = game.Lighting
	end
	if workspace:WaitForChild("Terrain"):FindFirstChild("Clouds") then
		self.clouds = workspace.Terrain:FindFirstChild("Clouds")
	else
		self.clouds = Instance.new("Clouds")
		self.clouds.Parent = workspace:WaitForChild("Terrain")
	end

	local weatherEvents = comm.new("weatherEvents")
	self.comm = weatherEvents
	self.events = {
		noiseAnimation = weatherEvents:remoteEvent("noiseAnimation"),
	}

	self.month, self.day, self.season, self.hasChanged, self.isNight =
		{ Name = "nil", Short = "nil", Number = 1 }, 1, "nil", false, false
	self.valuesInitialized = false
	self.currentDay = math.random(1, 365)
	self.currentMoonPhase = math.random(1, 8)
	self.randomSeed = if configuration.misc:GetAttribute("Seed") ~= 0
		then configuration.misc:GetAttribute("Seed")
		else 57814259801
	self.randomSeed = math.random(self.randomSeed, 0)
	print(self.randomSeed)
	data.randomSeed.Value = self.randomSeed
	self.seed = Random.new(self.randomSeed)
	self.currentClimateData = configuration.climateData:FindFirstChild("January")

	for _, v in pairs(serverModules:GetChildren()) do
		self:_initModule(v)
	end

	self.conversions:convertAllMonthData()
	self.conversions:convertMapSize()
	self.daylight:start()
	self.dynamicWeather:start()
	self:_newDay(self.currentDay)

	game.Lighting:GetPropertyChangedSignal("TimeOfDay"):Connect(function()
		self:_timeOfDay()
	end)

	truePrint("Server Started")
end

return weather
