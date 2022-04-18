function CreateCircle(Parent, X, Y, Color)
	local Circle = script.Circle:Clone()
	Circle.Parent = Parent.Background
	Circle.Position = UDim2.new(0, X - Parent.AbsolutePosition.X, 0, Y - Parent.AbsolutePosition.Y)
	Circle.ImageColor3 = Color
	
	Circle:TweenSizeAndPosition(UDim2.new(0, Parent.AbsoluteSize.X, 0, Parent.AbsoluteSize.X),
	UDim2.new(.5, -Parent.AbsoluteSize.X / 2, .5, -Parent.AbsoluteSize.X / 2), "Out", "Quad", .5)
	
	wait(.2)
	repeat
		Circle.ImageTransparency = Circle.ImageTransparency + .1
		wait(.02)
	until Circle.ImageTransparency >= 1
	Circle:Destroy()
	
end

return CreateCircle
