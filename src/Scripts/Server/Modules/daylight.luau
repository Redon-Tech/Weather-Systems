local dayLength = 1 --.05 -- Minutes
local RunService = game:GetService("RunService")

dayLength *= 60
return {
	dayLength = dayLength,
	start = function()
		local timeElapsed = 0
		RunService.Heartbeat:Connect(function(deltaTime)
			timeElapsed += deltaTime
			if timeElapsed >= dayLength then
				timeElapsed = 0
			end
			game.Lighting.ClockTime = (timeElapsed / dayLength) * 24
		end)
	end,
}
