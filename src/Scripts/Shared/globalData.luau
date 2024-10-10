export type weatherTypes =
	"Clear"
	| "Partly Cloudy"
	| "Mostly Cloudy"
	| "Cloudy"
	| "Drizzle"
	| "Showers"
	| "Rain"
	| "Thunderstorms"
	| "Strong Thunderstorms"

local globalData: {
	conditionData: {
		names: { string },
		precipIntensityAndChance: { intensity: number, chance: number },
		weatherDetermined: {
			number: weatherTypes,
		},
	},
	conditionOptions: {
		rising: { number },
		steady: { number },
		falling: { number },
	},
	pressure: {
		Pa: number,
		kPa: number,
		bar: number,
		mbar: number,
		psi: number,
		atm: number,
	},
	months: { { Name: string, Short: string, MinDays: number, MaxDays: number } },
} =
	{
		conditionData = {
			names = {
				[1] = "Settled Fine",
				[2] = "Fine Weather",
				[3] = "Fine Becoming Less Settled",
				[4] = "Fairly Fine Showery Later",
				[5] = "Showery Becoming more unsettled",
				[6] = "Unsettled, Rain later",
				[7] = "Rain at times, worse later.",
				[8] = "Rain at times, becoming very unsettled",
				[9] = "Very Unsettled, Rain",
				[10] = "Settled Fine",
				[11] = "Fine Weather",
				[12] = "Fine, Possibly showers",
				[13] = "Fairly Fine, Showers likely",
				[14] = "Showery Bright Intervals",
				[15] = "Changeable some rain",
				[16] = "Unsettled, rain at times",
				[17] = "Rain at Frequent Intervals",
				[18] = "Very Unsettled, Rain",
				[19] = "Stormy, much rain",
				[20] = "Settled Fine",
				[21] = "Fine Weather",
				[22] = "Becoming Fine",
				[23] = "Fairly Fine, Improving",
				[24] = "Fairly Fine, Possibly showers, early",
				[25] = "Showery Early, Improving",
				[26] = "Changeable Mending",
				[27] = "Rather Unsettled Clearing Later",
				[28] = "Unsettled, Probably Improving",
				[29] = "Unsettled, short fine Intervals",
				[30] = "Very Unsettled, Finer at times",
				[31] = "Stormy,possibly improving",
				[32] = "Stormy, much rain",
			},
			precipIntensityAndChance = {
				[1] = { intensity = 0.0, chance = 0.0 },
				[2] = { intensity = 0.0, chance = 0.0 },
				[3] = { intensity = 0.0, chance = 0.0 },
				[4] = { intensity = 0.1, chance = 0.1 },
				[5] = { intensity = 0.2, chance = 0.2 },
				[6] = { intensity = 0.3, chance = 0.3 },
				[7] = { intensity = 0.4, chance = 0.4 },
				[8] = { intensity = 0.5, chance = 0.5 },
				[9] = { intensity = 0.6, chance = 0.6 },
				[10] = { intensity = 0.0, chance = 0.0 },
				[11] = { intensity = 0.0, chance = 0.0 },
				[12] = { intensity = 0.1, chance = 0.1 },
				[13] = { intensity = 0.2, chance = 0.2 },
				[14] = { intensity = 0.3, chance = 0.3 },
				[15] = { intensity = 0.4, chance = 0.4 },
				[16] = { intensity = 0.5, chance = 0.5 },
				[17] = { intensity = 0.6, chance = 0.6 },
				[18] = { intensity = 0.7, chance = 0.7 },
				[19] = { intensity = 0.8, chance = 0.8 },
				[20] = { intensity = 0.0, chance = 0.0 },
				[21] = { intensity = 0.0, chance = 0.0 },
				[22] = { intensity = 0.1, chance = 0.1 },
				[23] = { intensity = 0.2, chance = 0.2 },
				[24] = { intensity = 0.3, chance = 0.3 },
				[25] = { intensity = 0.4, chance = 0.4 },
				[26] = { intensity = 0.5, chance = 0.5 },
				[27] = { intensity = 0.6, chance = 0.6 },
				[28] = { intensity = 0.7, chance = 0.7 },
				[29] = { intensity = 0.8, chance = 0.8 },
				[30] = { intensity = 0.9, chance = 0.9 },
				[31] = { intensity = 1.0, chance = 1.0 },
				[32] = { intensity = 1.0, chance = 1.0 },
			},
			weatherDetermined = {
				[1] = "Clear", --"Settled Fine",
				[2] = "Clear", --"Fine Weather",
				[3] = "Partly Cloudy", --"Fine Becoming Less Settled",
				[4] = "Mostly Cloudy", --"Fairly Fine Showery Later",
				[5] = "Drizzle", --"Showery Becoming more unsettled",
				[6] = "Cloudy", --"Unsettled, Rain later",
				[7] = "Drizzle", --"Rain at times, worse later.",
				[8] = "Showers", --"Rain at times, becoming very unsettled",
				[9] = "Rain", --"Very Unsettled, Rain",
				[10] = "Clear", --"Settled Fine",
				[11] = "Clear", --"Fine Weather",
				[12] = "Mostly Cloudy", --"Fine, Possibly showers",
				[13] = "Cloudy", --"Fairly Fine, Showers likely",
				[14] = "Drizzle", --"Showery Bright Intervals",
				[15] = "Showers", --"Changeable some rain",
				[16] = "Drizzle", --"Unsettled, rain at times",
				[17] = "Rain", --"Rain at Frequent Intervals",
				[18] = "Rain", --"Very Unsettled, Rain",
				[19] = "Thunderstorms", --"Stormy, much rain",
				[20] = "Partly Cloudy", --"Settled Fine",
				[21] = "Clear", --"Fine Weather",
				[22] = "Partly Cloudy", --"Becoming Fine",
				[23] = "Partly Cloudy", --"Fairly Fine, Improving",
				[24] = "Cloudy", --"Fairly Fine, Possibly showers, early",
				[25] = "Drizzle", --"Showery Early, Improving",
				[26] = "Drizzle", --"Changeable Mending",
				[27] = "Rain", --"Rather Unsettled Clearing Later",
				[28] = "Cloudy", --"Unsettled, Probably Improving",
				[29] = "Rain", --"Unsettled, short fine Intervals",
				[30] = "Heavy Rain", --"Very Unsettled, Finer at times",
				[31] = "Thunderstorms", --"Stormy,possibly improving",
				[32] = "Strong Thunderstorms", --"Stormy, much rain",
			},
		},
		conditionOptions = {
			rising = { 25, 25, 25, 24, 24, 19, 16, 12, 11, 9, 8, 6, 5, 2, 1, 1, 0, 0, 0, 0, 0, 0 },
			steady = { 25, 25, 25, 25, 25, 25, 23, 23, 22, 18, 15, 13, 10, 4, 1, 1, 0, 0, 0, 0, 0, 0 },
			falling = { 25, 25, 25, 25, 25, 25, 25, 25, 23, 23, 21, 20, 17, 14, 7, 3, 1, 1, 1, 0, 0, 0 },
		},
		pressure = {
			Pa = 0.01, -- Pascal to millibar
			kPa = 10, -- Kilopascal to millibar
			bar = 1000, -- Bar to millibar
			mbar = 1, -- Millibar to millibar
			psi = 68.9475729, -- Pound per Square Inch to millibar
			atm = 1013.25, -- Standard Atmosphere to millibar
		},
		months = {
			{
				Name = "January",
				Short = "Jan",
				MinDays = 0,
				MaxDays = 31,
			},
			{
				Name = "February",
				Short = "Feb",
				MinDays = 31,
				MaxDays = 59,
			},
			{
				Name = "March",
				Short = "Mar",
				MinDays = 59,
				MaxDays = 90,
			},
			{
				Name = "April",
				Short = "Apr",
				MinDays = 90,
				MaxDays = 120,
			},
			{
				Name = "May",
				Short = "May",
				MinDays = 120,
				MaxDays = 151,
			},
			{
				Name = "June",
				Short = "Jun",
				MinDays = 151,
				MaxDays = 181,
			},
			{
				Name = "July",
				Short = "Jul",
				MinDays = 181,
				MaxDays = 212,
			},
			{
				Name = "August",
				Short = "Aug",
				MinDays = 212,
				MaxDays = 243,
			},
			{
				Name = "September",
				Short = "Sep",
				MinDays = 243,
				MaxDays = 273,
			},
			{
				Name = "October",
				Short = "Oct",
				MinDays = 273,
				MaxDays = 304,
			},
			{
				Name = "November",
				Short = "Nov",
				MinDays = 304,
				MaxDays = 334,
			},
			{
				Name = "December",
				Short = "Dec",
				MinDays = 334,
				MaxDays = 365,
			},
		},
	}

return globalData
