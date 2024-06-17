local Convert = {}

function Convert.Number(String)
	local Time = game.Lighting:GetMinutesAfterMidnight()
	
	if String == "Sunny" or String == "Clear" then
		return 1
	elseif String == "Partly Cloudy" then
		return 2
	elseif String == "Mostly Cloudy" then
		return 3
	elseif String == "Cloudy" then
		return 4
	elseif String == "Flurries" or String == "Freezing Drizzle" or String == "Drizzle" then
		return 5
	elseif String == "Snow Showers" or String == "Rain / Snow Showers" or String == "Showers" then
		return 6
	elseif String == "Snow" or String == "Rain / Snow" or String == "Rain" then
		return 7
	elseif String == "Heavy Snow" or String == "Heavy Rain / Snow" or String == "Heavy Rain" or String == "Scattered Thunderstorms" or String == "Isolated Thunderstorms" or String == "Thunderstorms" then
		return 8
	elseif String == "Strong Thunderstorms" then
		return 9
	end
end

function Convert.String(Number, Temperature, Time, Storm)	
	if Number == 1 then if Time == "Day" then return "Sunny" else return "Clear" end
	elseif Number == 2 then return "Partly Cloudy"
	elseif Number == 3 then return "Mostly Cloudy"
	elseif Number == 4 then return "Cloudy"
	elseif Number == 5 then
		if Temperature < 31 then return "Flurries"
		elseif Temperature < 34 then return "Freezing Drizzle"
		else return "Drizzle" end
	elseif Number == 6 then
		if Storm == 1 then return "Isolated Thunderstorms"
		elseif Storm == 2 then return "Thunderstorms"
		elseif Temperature < 31 then return "Snow Showers"
		elseif Temperature < 34 then return "Rain / Snow Showers"
		else return "Showers" end
	elseif Number == 7 then
		if Storm == 1 then return "Scattered Thunderstorms"
		elseif Storm == 2 then return "Thunderstorms"
		elseif Temperature < 31 then return "Snow"
		elseif Temperature < 34 then return "Rain / Snow"
		else return "Rain" end
	elseif Number == 8 then
		if Storm == 1 then return "Thunderstorms"
		elseif Storm == 2 then return "Thunderstorms"
		elseif Temperature < 31 then return "Heavy Snow"
		elseif Temperature < 34 then return "Heavy Rain / Snow"
		else return "Heavy Rain" end
	elseif Number == 9 then
		return "Strong Thunderstorms"
	end
end

return Convert