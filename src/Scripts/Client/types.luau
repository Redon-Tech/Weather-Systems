local ReplicatedStorage = game:GetService("ReplicatedStorage")

local wsShared = ReplicatedStorage:WaitForChild("WeatherSystem_Shared")
local sharedModules = wsShared:WaitForChild("Modules")
local comm = require(sharedModules:WaitForChild("comm"))

export type client = {
	modules: { string },

	comm: comm.comm,
	events: {
		noiseAnimation: comm.remoteEvent,
	},
	randomSeed: number,
	random: Random,

	_initModule: (self: client, module: ModuleScript) -> (),
	start: (self: client) -> (),

	-- Modules
	dynamicWeather: dynamicWeather,
	rainHandler: rainHandler,
}

export type dynamicWeather = client & {
	lastAnimateOffset: Vector2,
	animateOffset: Vector2,
	octaves: number,
	lacunarity: number,
	persistence: number,
	amplitude: number,
	frequency: number,
	updateAmount: number,
	updating: boolean,

	serverLastAnimateOffset: Vector2,
	serverAnimateOffset: Vector2,
	currentCloudIntensity: number,
	cloudIntensity: number,
	currentPrecipIntensity: number,
	precipIntensity: number,
	rootPart: BasePart,
	clouds: Clouds,

	currentChunk: Vector2?,

	_adjustValues: (self: dynamicWeather) -> (),
	_loop: (self: dynamicWeather, deltaTime: number) -> (),
	_adjustAnimation: (self: dynamicWeather, lastAnimateOffset: Vector2, animateOffset: Vector2) -> (),
	start: (self: dynamicWeather) -> (),
}

export type rainHandler = client & {
	rainMode: "rain" | "snow",
	rainEnabled: boolean,

	setSnow: (self: rainHandler) -> (),
	setRain: (self: rainHandler) -> (),
	setIntensity: (self: rainHandler, intensity: number) -> (),
	enable: (self: rainHandler) -> (),
	disable: (self: rainHandler) -> (),
}

return nil
