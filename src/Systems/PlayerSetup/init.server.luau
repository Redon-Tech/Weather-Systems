local objects = script:GetChildren()
for i = 1, #objects do
	if not script.Parent.Parent:FindFirstChild(objects[i].Name) then
		objects[i].Parent = script.Parent.Parent
		if objects[i]:IsA("Script") then objects[i].Disabled = false end
	end
end