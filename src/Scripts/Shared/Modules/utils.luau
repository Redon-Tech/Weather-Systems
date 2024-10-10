local utils = {}

function utils.getWindDirection(vector: Vector2): string
	local angle = math.atan2(vector.Y, vector.X)
	local degrees = math.deg(angle)

	-- Normalize degrees to 0-360
	degrees = (degrees + 360) % 360

	local directions =
		{ "N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW" }
	local index = math.floor((degrees + 11.25) / 22.5) % 16 + 1

	return directions[index]
end

function utils.lerp(start: number, goal: number, alpha: number): number
	return start + (goal - start) * alpha
end

function utils.lerpVector3(start: Vector3, goal: Vector3, alpha: number): Vector3
	return Vector3.new(
		utils.lerp(start.X, goal.X, alpha),
		utils.lerp(start.Y, goal.Y, alpha),
		utils.lerp(start.Z, goal.Z, alpha)
	)
end

return utils
