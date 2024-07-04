local weather = require(script.Parent.weather)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("WeatherSystem_Shared")
local Modules = Shared:WaitForChild("Modules")
local comm = require(Modules:WaitForChild("comm"))

comm.setup()

weather:start()
