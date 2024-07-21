local daylight = {}

local dayLength = 1 --.05 -- Minutes
local RunService = game:GetService("RunService")

dayLength *= 60 -- Convert to seconds
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

		game.Lighting.ClockTime = (self.timeElapsed / dayLength) * 24
		self.dataHandler:heartbeat(deltaTime)
	end)
end

return daylight
