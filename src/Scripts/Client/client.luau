local ReplicatedStorage = game:GetService("ReplicatedStorage")

local wsShared = ReplicatedStorage:WaitForChild("WeatherSystem_Shared")
local configuration = wsShared:WaitForChild("Configuration")
local data = wsShared:WaitForChild("Data")
local sharedModules = wsShared:WaitForChild("Modules")
local comm = require(sharedModules:WaitForChild("comm"))
local dynamicWeather = script.Parent:WaitForChild("dynamicWeather")
local rainHandler = script.Parent:WaitForChild("rainHandler")

local client = {
	modules = {},
}

local isDebug = configuration:GetAttribute("debug")
local print = function(...)
	print(`\n		[RTRS Client]:`, ...)
end
local warn = function(...)
	if isDebug then
		warn(`[RTWS Client]: `, ...)
	end
end

function client:_initModule(module: ModuleScript)
	local tbl = require(module)
	assert(type(tbl) == "table", `invalid return from module {module.Name} (table expected, got {type(tbl)})`)
	if table.find(self.modules, module.Name) then
		warn(`module {module.Name} has already been initialized, skipping`)
		return
	end

	self[module.Name] = tbl
	table.insert(self.modules, module.Name)

	local success, err = pcall(function()
		setmetatable(tbl, { __index = client })
	end)
	assert(success, `failed to set metatable for module {module.Name}: {err}`)
end

function client:start()
	print(`Starting Client\n		Version: {configuration:GetAttribute("version")}\n		Debug: {isDebug}`)
	setmetatable(client, { __index = client })

	local weatherEvents = comm.new("weatherEvents")
	self.comm = weatherEvents
	self.events = {
		noiseAnimation = weatherEvents:remoteEvent("noiseAnimation"),
	}

	self.randomSeed = data.randomSeed.Value
	self.random = Random.new(self.randomSeed)

	self:_initModule(dynamicWeather)
	self:_initModule(rainHandler)

	self.dynamicWeather:start()
	print("Client Started")
end

return client
