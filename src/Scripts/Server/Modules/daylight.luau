local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local wsShared = ReplicatedStorage:WaitForChild("WeatherSystem_Shared")
local configuration = wsShared:WaitForChild("Configuration")
local dayCycle = configuration:WaitForChild("dayCycle")
local types = require(script.Parent.Parent.types)

local daylight = {} :: types.daylight

local enabled = dayCycle:GetAttribute("enabled") or false
local dayLength = dayCycle:GetAttribute("dayLength") or 24
local startTime = dayCycle:GetAttribute("startTime") or 0
local realTime = dayCycle:GetAttribute("realTime") or false
local realTimeZone = dayCycle:GetAttribute("realTimeZone") or 0

if startTime > dayLength then
	startTime = dayLength / 2
end

dayLength *= 60 -- Convert to seconds
startTime *= 60
if realTime == true then
	dayLength = 86400
end

function daylight.getSyncedTime(self: types.daylight)
	local currentTime = DateTime.now():ToUniversalTime()
	local currentHour = (currentTime.Hour + realTimeZone) % 24
	return (currentHour * 3600) + (currentTime.Minute * 60) + currentTime.Second
end

function daylight.start(self: types.daylight)
	if enabled == false then
		RunService.Heartbeat:Connect(function(deltaTime)
			self.dataHandler:heartbeat(deltaTime)
		end)
		return
	end

	self.dayLength = dayLength

	self.timeElapsed = startTime
	if realTime == true then
		self.timeElapsed = self:getSyncedTime()
	end

	self.percentageElapsed = self.timeElapsed / dayLength
	RunService.Heartbeat:Connect(function(deltaTime)
		self.timeElapsed += deltaTime
		if self.timeElapsed >= dayLength then
			if realTime == true then
				self.timeElapsed = self:getSyncedTime()
			else
				self.timeElapsed = 0
			end
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
