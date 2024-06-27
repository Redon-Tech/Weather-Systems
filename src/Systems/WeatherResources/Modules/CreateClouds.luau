function CreateClouds()
	local Model = Instance.new("Model")
	Model.Name = "SmallClouds"
	Model.Parent = game.Workspace
	local Part = Instance.new("Part")
	Part.Name = "Cloud"
	Part.Size = Vector3.new(0.1,0.1,0.1)
	Part.Position = Vector3.new(0, -100, 0)
	Part.Anchored = true
	Part.Parent = Model
	--[[local SmallClouds = script.Parent.Parent.Parts.SmallClouds
	SmallClouds.Parent = game.Workspace
	
	local WorkspaceSize = game.Workspace:GetExtentsSize()
	local CloudX = math.ceil(WorkspaceSize.x / 3500)
	local CloudZ = math.ceil(WorkspaceSize.z / 3500)
	
	local LastCloud
	for i = 1, CloudX do
		if i > 1 then
			local NewCloud = LastCloud:Clone()
			NewCloud.Parent = SmallClouds
			NewCloud.Position = Vector3.new(LastCloud.Position.X + 3500, 1000, 0)
		end
		LastCloud = SmallClouds.Cloud
	end
	for _, Cloud in pairs(SmallClouds:GetChildren()) do
		for i = 1, CloudZ do
			if i > 2 then
				local NewCloud = Cloud:Clone()
				NewCloud.Parent = SmallClouds
				NewCloud.Position = Vector3.new(NewCloud.Position.X, 1000, i * 3500)
			end
		end
	end]]
end

return CreateClouds