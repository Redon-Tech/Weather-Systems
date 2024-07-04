local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("WeatherSystem_Shared")
local Data = Shared:WaitForChild("Data")

local dynamicWeatherShared = {}

export type values = {
	amplitude: number,
	persistence: number,
	lacunarity: number,
	octaves: number,
}

function dynamicWeatherShared:getValues(): values
	local adjustedPressure = ((Data.pressure.Value - 1000) / (1028.6 - 1000)) * 100
	local intensity = Data.intensity.Value
	local precipChance = Data.precipChance.Value
	local amplitude = (
		(Data.temperature.Value * 0.4)
		+ (Data.humidity.Value * 0.9)
		+ (adjustedPressure * 0.8)
		+ intensity * 100
	) * precipChance
	local persistence = 0.6 * intensity + 0.1
	local lacunarity = 4.5 * (1 - intensity)
	local octaves = 8 * (1 - intensity)

	amplitude = math.clamp(amplitude / 100, 0.1, 2)
	persistence = math.clamp(persistence, 0.1, 0.4)
	lacunarity = math.clamp(lacunarity, 1.5, 3)
	octaves = math.clamp(octaves, 4, 8)
	return {
		amplitude = amplitude,
		persistence = persistence,
		lacunarity = lacunarity,
		octaves = octaves,
	}
end

function dynamicWeatherShared:calculateElevationAtChunk(
	chunk: Vector2,
	t_frequency: number,
	t_amplitude: number,
	octaves: number,
	persistence: number,
	lacunarity: number,
	randomSeed: number,
	animateOffset: Vector2
)
	local elevation = 0

	for i = 1, octaves do
		local sample_x = chunk.X / 101 * t_frequency + (animateOffset.X * 0.1)
		local sample_y = chunk.Y / 101 * t_frequency + (animateOffset.Y * 0.1)

		elevation += math.noise(sample_x, sample_y, randomSeed) * t_amplitude

		t_amplitude = t_amplitude * persistence
		t_frequency = t_frequency * lacunarity
	end

	elevation = math.clamp(elevation, -0.5, 0.5)
	return elevation + 0.5
end

return dynamicWeatherShared
