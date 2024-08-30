local daylight = {}

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("WeatherSystem_Shared")
local Configuration = Shared:WaitForChild("Configuration")
local dayCycle = Configuration:WaitForChild("dayCycle")

local dayLength = DayCycle:GetAttribute("dayLength") or 24
local realTime = DayCycle:GetAttribute("realTime") or false
local realTimeTimeZone = DayCycle:GetAttribute("realTimeTimeZone") or 0

dayLength *= 60 -- Convert to seconds
if realTime == true then
	dayLength = 1440
end

function daylight:start()
	self.dayLength = dayLength

	self.timeElapsed = 0
	self.percentageElapsed = 0
	RunService.Heartbeat:Connect(function(deltaTime)
		self.timeElapsed += deltaTime
		if self.timeElapsed >= dayLength then
			self.timeElapsed = 0
		end
		if self.timeElapsed >= dayLength / 2 then
			self.isPastHalf = true
		else
			self.isPastHalf = false
		end
		self.percentageElapsed = self.timeElapsed / dayLength

		Lighting.ClockTime = (self.timeElapsed / dayLength) * 24
		self.dataHandler:heartbeat(deltaTime)
	end)
end

return daylight
