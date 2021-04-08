function CreateClouds()
	local SmallClouds = script.Parent.Parent.Parts.SmallClouds
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
	end
end

return CreateClouds