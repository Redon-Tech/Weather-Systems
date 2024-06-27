--((current - target) / 2) + target + (((current - target) / 2) * math.cos((currenttime * math.pi) / lengthoftime))

function CloudVisiblity(TargetSmall, TargetLarge, Small, Large, Time)
	for i = 1, Time * 10 do
		local TransSmall = ((Small[1].Transparency - TargetSmall) / 2) + TargetSmall + (((Small[1].Transparency - TargetSmall) / 2) * math.cos((i * math.pi) / (Time * 10)))
		local TransLarge = ((Large[1].Transparency - TargetLarge) / 2) + TargetLarge + (((Large[1].Transparency - TargetLarge) / 2) * math.cos((i * math.pi) / (Time * 10)))
		for _, Child in pairs(Small) do Child.Transparency = TransSmall end
		for _, Child in pairs(Large) do Child.Transparency = TransLarge end
		wait(.1)
	end
	for _, Child in pairs(Small) do Child.Transparency = TargetSmall end
	for _, Child in pairs(Large) do Child.Transparency = TargetLarge end
end

return CloudVisiblity