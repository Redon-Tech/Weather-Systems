function CreateLightning()
	
	repeat wait() until #game.Players:GetPlayers() > 0
	
	math.randomseed(tick())
	local LightningModel = Instance.new("Model")
	LightningModel.Name = "Lightning"
	
	local LightningPart = game.ReplicatedStorage.WeatherResources.Parts.Lightning
	
	local Script = script.LightningScript:clone()
	Script.Disabled = false
	Script.Parent = LightningModel
		
	function GetPosition()
		local Players = game.Players:GetPlayers()
		local Player = Players[math.random(1, #game.Players:GetPlayers())]
		if Player.Character:FindFirstChild("Torso") then return Player.Character.Torso.Position elseif Player.Character:FindFirstChild("UpperTorso") then return Player.Character.UpperTorso.Position else GetPosition() end
	end

	local Position = GetPosition()
	
	local XMult = 0
	repeat XMult = math.random(-1, 1) until XMult ~= 0
	local ZMult = 0
	repeat ZMult = math.random(-1, 1) until ZMult ~= 0
	local LowXBound, LowZBound
	if math.random(0, 10) == 5 then
		LowXBound, LowZBound = 0, 0
	else LowXBound, LowZBound = 200, 200 end
	
	local Origin = Vector3.new(Position.x + XMult * math.random(LowXBound, 2000), Position.y + 600, Position.z + ZMult * math.random(LowZBound, 2000))
	local Last = Origin
	local Depth = 800
	local Impacted = true
	local Segments = 0
	
	while Depth > 0 and Impacted and Segments < 40 do
		
		Segments = Segments + 1
		local Range = 20
		local Next = Last + Vector3.new(math.random(-Range, Range), math.random(-Range * 2, -5), math.random(-Range, Range))
		local Parts = game.Workspace:FindPartsInRegion3(Region3.new(Last - Vector3.new(Range / 2, Range * 2, Range / 2), Last + Vector3.new(Range / 2, -5, Range / 2)), nil, 100)
		
		if Parts then
			if #Parts > 0 then
				local Highest = Next
				for i2, v2 in ipairs(Parts) do if v2 then if v2.Position.y > Highest.y then Highest = v2.Position end end end Next = Highest
			end
		end
		
		local Distance = (Last - Next).magnitude
		local Hit, Pos = game.Workspace:FindPartOnRay(Ray.new(Last, Next - Last))
		
		if Hit ~= nil and Pos ~= nil then
			Impacted = false
			local Explosion = Instance.new("Explosion")
			Explosion.BlastRadius = 50
			Explosion.BlastPressure = 20000000000
			Explosion.ExplosionType = Enum.ExplosionType.NoCrater
			Explosion.Position = Pos
			Explosion.Parent = LightningModel
		end
		
		if Pos ~= nil then Next = Pos end
		
		Depth = Next.y
		local Part = LightningPart:Clone()
		local Distance = (Last - Next).magnitude
		Part.Size = Vector3.new(3, Distance, 3)
		Part.CFrame = CFrame.new(Last, Next) * CFrame.Angles(math.pi/2, 0, 0) * CFrame.new(0, -Distance / 2, 0)
		Part.Parent = LightningModel
		Last = Next
	end
	
	LightningModel.Parent = game.Workspace
	
end

return CreateLightning