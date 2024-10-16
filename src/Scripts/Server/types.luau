local ReplicatedStorage = game:GetService("ReplicatedStorage")

local wsShared = ReplicatedStorage:WaitForChild("WeatherSystem_Shared")
local globalData = require(wsShared:WaitForChild("globalData"))
local sharedModules = wsShared:WaitForChild("Modules")
local comm = require(sharedModules:WaitForChild("comm"))

export type weather = {
	modules: { string },

	month: {
		Name: string,
		Short: string,
		Number: number,
	},
	season: string,
	day: number,
	currentClimateData: Folder,
	hasChanged: boolean,

	currentDay: number,
	currentMoonPhase: number,
	sky: Sky,
	isNight: boolean,
	valuesInitialized: boolean,

	clouds: Clouds,
	randomSeed: number,
	seed: Random,

	comm: comm.comm,
	events: {
		noiseAnimation: comm.remoteEventServer,
		lightningEvent: comm.remoteEventServer,
	},

	_newDay: (self: weather, dayNum: number) -> (),
	_timeOfDay: (self: weather) -> (),
	_initValues: (self: weather) -> (),
	_initModule: (self: weather, module: ModuleScript) -> (),
	start: (self: weather) -> (),

	conversions: conversions,
	dataHandler: dataHandler,
	daylight: daylight,
	dynamicWeather: dynamicWeather,
	zWeather: zWeather,
	realTime: realTime,
	lightning: lightning,
}

export type conversions = weather & {
	convertPressure: (self: conversions, input: number, from: string) -> (),
	convertAllMonthData: (self: conversions) -> (),
	convertMapSize: (self: conversions) -> (),
}

export type dataHandler = weather & {
	started: boolean,

	startingPressure: number,
	goalPressure: number,
	startingTemperature: number,
	goalTemperature: number,
	startingHumidity: number,
	goalHumidity: number,
	startingWind: Vector3,
	goalWind: Vector3,
	startingPrecipChance: number,
	goalPrecipChance: number,
	startingPrecipIntensity: number,
	goalPrecipIntensity: number,
	currentzForecast: number,

	currentDataIsDayToNight: boolean,

	_calculateNextPressure: (self: dataHandler, trend: number?) -> number,
	_calculateNextTemperature: (self: dataHandler, getCurrent: boolean?) -> number,
	_calculateNextHumidity: (self: dataHandler, getCurrent: boolean?) -> number,
	getPressureTrend: (self: dataHandler) -> number,
	_calculateNextWind: (self: dataHandler) -> Vector3,
	_calculateNextPrecipData: (
		self: dataHandler,
		pressure: number,
		pressureTrend: number,
		newWind: Vector3
	) -> typeof(globalData.conditionData.precipIntensityAndChance[1]) & { value: number },
	_nextData: (
		self: dataHandler,
		startingPressure: number,
		startingTemperature: number,
		startingHumidity: number,
		pressureTrend: number,
		startingPrecipData: { chance: number, intensity: number }
	) -> (),
	heartbeat: (self: dataHandler, deltaTime: number) -> (),
	start: (self: dataHandler) -> (),
}

export type daylight = weather & {
	dayLength: number,
	timeElapsed: number,
	percentageElapsed: number,
	isPastHalf: boolean,

	getSyncedTime: (self: daylight) -> number,
	start: (self: daylight) -> (),
}

export type dynamicWeather = weather & {
	lastAnimateOffset: Vector2,
	animateOffset: Vector2,
	timeElapsed: number,
	mapSize: Vector2,
	mapSizeMin: Vector2,
	mapSizeMax: Vector2,
	currentWind: Vector3,
	loop: RBXScriptConnection | false,

	_loop: (self: dynamicWeather, deltaTime: number) -> (),
	getAnimationData: (self: dynamicWeather) -> (Vector2, Vector2),
	startLoop: (self: dynamicWeather) -> (),
	start: (self: dynamicWeather) -> (),
}

export type zWeather = weather & {
	enabled: boolean,

	weatherChanged: (self: zWeather) -> (),
	start: (self: zWeather) -> (),
}

export type realTime = weather & {
	enabled: boolean,

	startLoop: (self: realTime) -> (),
	start: (self: zWeather) -> (),
}

export type lightning = weather & {
	enabled: boolean,
	task: thread | false,

	castLightning: (self: lightning, position: Vector3) -> (),
	weatherChanged: (self: lightning) -> (),
	start: (self: lightning) -> (),
}

return nil
