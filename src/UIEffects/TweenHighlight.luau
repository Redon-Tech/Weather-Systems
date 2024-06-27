function IsWithinObject(Parent, Mouse)
	if (Mouse.X >= Parent.AbsolutePosition.X and Mouse.X <= Parent.AbsolutePosition.X + Parent.AbsoluteSize.X) and
	(Mouse.Y >= Parent.AbsolutePosition.Y and Mouse.Y <= Parent.AbsolutePosition.Y + Parent.AbsoluteSize.Y) then
		return true
	else return false end
end

function TweenHighlight(Parent, EndSize, CustomSize, Mouse)
	
	if Parent:FindFirstChild("Highlight") then
		if CustomSize then Parent.Highlight:TweenSize(CustomSize, "Out", "Quart", .25, true) else
		Parent.Highlight:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quart", .25, true) end
	
		local Move
		Move = Mouse.Move:connect(function()
			if not IsWithinObject(Parent, Mouse) then
				Move:disconnect()
				Parent.Highlight:TweenSize(EndSize, "Out", "Quart", .25, true)
			end
		end)
	else
		print("ERROR: " .. Parent:GetFullName() .. " doesn't have a highlight object!")
	end
end

return TweenHighlight
