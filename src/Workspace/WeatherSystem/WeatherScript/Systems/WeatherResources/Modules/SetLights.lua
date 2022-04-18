function SetLights(Bool, Lights, Gantries)
	for _, Light in pairs(Lights) do
		for _, Part in pairs(Light:GetChildren()) do
			if Part.Name == "Light" then
				if Part:FindFirstChild("PointLight") then Part.PointLight.Enabled = Bool end
				if Bool == true then Part.FakeLight.Material = Enum.Material.Neon else Part.FakeLight.Material = Enum.Material.SmoothPlastic end
			end
		end
	end
	for _, Gantry in pairs(Gantries) do
		for _, Part in pairs(Gantry:GetChildren()) do
			if Part.Name == "Sign" then
				if Part:FindFirstChild("Light1") then Part.Light1.DL.Enabled = Bool end
				if Part:FindFirstChild("Light2") then Part.Light2.DL.Enabled = Bool end
			end
		end
	end
end

return SetLights