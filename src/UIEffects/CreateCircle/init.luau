function CreateCircle(Parent, X, Y, Color)
	local Circle = script.Circle:Clone()
	Circle.Parent = Parent.Background
	Circle.Position = UDim2.new(0, X - Parent.AbsolutePosition.X, 0, Y - Parent.AbsolutePosition.Y)
	Circle.ImageColor3 = Color

	Circle:TweenSizeAndPosition(
		UDim2.new(0, Parent.AbsoluteSize.X, 0, Parent.AbsoluteSize.X),
		UDim2.new(0.5, -Parent.AbsoluteSize.X / 2, 0.5, -Parent.AbsoluteSize.X / 2),
		"Out",
		"Quad",
		0.5
	)

	wait(0.2)
	repeat
		Circle.ImageTransparency = Circle.ImageTransparency + 0.1
		wait(0.02)
	until Circle.ImageTransparency >= 1
	Circle:Destroy()
end

return CreateCircle
