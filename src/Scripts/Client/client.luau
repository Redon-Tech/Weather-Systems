local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("WeatherSystem_Shared")
local Configuration = Shared:WaitForChild("Configuration")
local Data = Shared:WaitForChild("Data")
local sharedModules = Shared:WaitForChild("Modules")
local comm = require(sharedModules:WaitForChild("comm"))
local dynamicWeather = script.Parent:WaitForChild("dynamicWeather")

local client = {
	modules = {},
}

local isDebug = Configuration:GetAttribute("debug")
local print = function(...)
	print(`[RTWS Client]: `, ...)
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
	print("Starting client...")
	setmetatable(client, { __index = client })

	local weatherEvents = comm.new("weatherEvents")
	self.comm = weatherEvents
	self.events = {
		noiseAnimation = weatherEvents:remoteEvent("noiseAnimation"),
	}

	self.randomSeed = Data.randomSeed.Value
	self.random = Random.new(self.randomSeed)

	self:_initModule(dynamicWeather)

	self.dynamicWeather:start()
	print("Client started")
end

return client
