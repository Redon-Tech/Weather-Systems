sp = script.Parent
frames = 10
bright = game.Lighting.Brightness
wait()
game.Lighting.Brightness = 10
for frame = 1, frames do
	wait()
	for i,v in ipairs(sp:GetChildren()) do
		if v then
			if v.className=="Part" then
				v.Transparency=frame/frames
			end
		end
	end
end
game.Lighting.Brightness = bright
sp:remove()




