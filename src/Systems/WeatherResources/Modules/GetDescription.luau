local Settings = game.ReplicatedStorage:WaitForChild("WeatherResources"):WaitForChild("Settings")

function Description(Time, Weather, Chance, Temperature)
	
	local Directions = {"N", "NNW", "NW", "WNW", "W", "WSW", "SW", "SSW", "S", "SSE", "SE", "ESE", "E", "ENE", "NE", "NNE"}
	
	local WeatherDescription, TemperatureDescription, WindDescription, ChanceDescription
	
	
	if Weather == "Sunny" then
		
		WeatherDescription = "Abundant sunshine."
		
	elseif Weather == "Clear" then
		
		WeatherDescription = "Clear skies."
		
	elseif Weather == "Partly Cloudy" then
		
		WeatherDescription = "Partly cloudy skies."
		
	elseif Weather == "Mostly Cloudy" then
		
		WeatherDescription = "Mostly cloudy skies."
		
	elseif Weather == "Cloudy" then
		
		WeatherDescription = "Mainly cloudy."
		
	elseif Weather == "Drizzle" then
		
		if Temperature < 32 then
			WeatherDescription = "Slight chance of flurries changing into a drizzle."
		elseif Temperature < 34 then
			WeatherDescription = "Slight chance of a freezing drizzle changing into a drizzle."
		else
			WeatherDescription = "Mainly cloudy with a slight chance of drizzle."
		end
		
	elseif Weather == "Freezing Drizzle" then
		
		if Temperature < 32 then
			WeatherDescription = "Slight chance of flurries changing into a freezing drizzle."
		elseif Temperature < 34 then
			WeatherDescription = "Mainly cloudy with a slight chance of freezing drizzle."
		else
			WeatherDescription = "Slight chance of a drizzle changing into a freezing drizzle."
		end
		
	elseif Weather == "Flurries" then
		
		if Temperature < 32 then
			WeatherDescription = "Mainly cloudy with a slight chance of flurries."
		elseif Temperature < 34 then
			WeatherDescription = "Mainly cloudy with a slight chance of a freezing drizzle changing into flurries."
		else
			WeatherDescription = "Mainly cloudy with a slight change of a drizzle changing into flurries."
		end
		
	elseif Weather == "Showers" then
		
		if Temperature < 32 then
			WeatherDescription = "Mainly cloudy with a chance of snow showers changing into rain showers."
		elseif Temperature < 34 then
			WeatherDescription = "Mainly cloudy with a chance of a wintry mix changing into rain showers."
		else
			WeatherDescription = "Mainly cloudy with a chance of rain showers."
		end
		
	elseif Weather == "Rain / Snow Showers" then
		
		if Temperature < 32 then
			WeatherDescription = "Mainly cloudy with a chance of snow showers changing into a wintry mix."
		elseif Temperature < 34 then
			WeatherDescription = "Mainly cloudy with a chance of a wintry mix."
		else
			WeatherDescription = "Mainly cloudy with a chance of rain showers changing into a wintry mix."
		end
		
	elseif Weather == "Snow Showers" then
		
		if Temperature < 32 then
			WeatherDescription = "Mainly cloudy with a chance of snow showers."
		elseif Temperature < 34 then
			WeatherDescription = "Mainly cloudy with a chance of a wintry mix changing into snow showers."
		else
			WeatherDescription = "Mainly cloudy with a chance of rain showers changing into snow showers."
		end
	
	elseif Weather == "Rain" then
		
		if Temperature < 32 then
			WeatherDescription = "Mainly cloudy with snow changing into all rain."
		elseif Temperature < 34 then
			WeatherDescription = "Mainly cloudy with a wintry mix changing into rain."
		else
			WeatherDescription = "Mainly cloudy with a steady rain."
		end
		
	elseif Weather == "Rain / Snow" then
		
		if Temperature < 32 then
			WeatherDescription = "Mainly cloudy with snow changing into a wintry mix."
		elseif Temperature < 34 then
			WeatherDescription = "Mainly cloudy with a steady wintry mix."
		else
			WeatherDescription = "Mainly cloudy with rain changing into a wintry mix."
		end
		
	elseif Weather == "Snow" then
		
		if Temperature < 32 then
			WeatherDescription = "Mainly cloudy with a steady snow."
		elseif Temperature < 34 then
			WeatherDescription = "Mainly cloudy with a wintry mix changing into snow."
		else
			WeatherDescription = "Mainly cloudy with rain changing into all snow."
		end
		
	elseif Weather == "Heavy Rain" then
		
		if Temperature < 32 then
			WeatherDescription = "Mainly cloudy with snow changing into all rain. Rain and snow may be heavy at times."
		elseif Temperature < 34 then
			WeatherDescription = "Mainly cloudy with a wintry mix changing into rain. Rain and snow may be heavy at times."
		else
			WeatherDescription = "Mainly cloudy with a steady rain. Rain may be heavy at times."
		end
		
	elseif Weather == "Heavy Rain / Snow" then
		
		if Temperature < 32 then
			WeatherDescription = "Mainly cloudy with snow changing into a wintry mix. Rain and snow may be heavy at times."
		elseif Temperature < 34 then
			WeatherDescription = "Mainly cloudy with a steady wintry mix. Rain and snow may be heavy at times."
		else
			WeatherDescription = "Mainly cloudy with rain changing into a wintry mix. Rain and snow may be heavy at times."
		end
		
	elseif Weather == "Heavy Snow" then
		
		if Temperature < 32 then
			WeatherDescription = "Mainly cloudy with a steady snow. Snow may be heavy at times."
		elseif Temperature < 34 then
			WeatherDescription = "Mainly cloudy with a wintry mix changing into snow. Rain and snow may be heavy at times."
		else
			WeatherDescription = "Mainly cloudy with rain changing into all snow. Rain and snow may be heavy at times."
		end
		
	elseif Weather == "Isolated Thunderstorms" then
		
		WeatherDescription = "Variable clouds with a slight chance of a thunderstorm."
		
	elseif Weather == "Scattered Thunderstorms" then
		
		WeatherDescription = "Variable clouds with a chance of a scattered thunderstorm."
		
	elseif Weather == "Thunderstorms" then
		
		WeatherDescription = "Cloudy with thunderstorms."
		
	elseif Weather == "Strong Thunderstorms" then
		
		WeatherDescription = "Cloudy with strong thunderstorms.  Storms may contain heavy rain, gusty winds, and hail."
		
	else
		
		WeatherDescription = "ERROR 404: THIS WEATHER DOESN'T EXIST LOL."
	
	end
	
	
	if Time == "Day" then
		
		if Settings.UseMetric.Value then TemperatureDescription = " High "..tostring(math.floor((5/9) * (Temperature - 32))).."*C."
		else TemperatureDescription = " High "..tostring(Temperature).."*F." end
		
		if Temperature > 95 then
			TemperatureDescription = " Hot. "..TemperatureDescription
		elseif Temperature < 25 then
			TemperatureDescription = " Cold. "..TemperatureDescription
		end
	
	elseif Time == "Night" then
		
		if Settings.UseMetric.Value then TemperatureDescription = " Low "..tostring(math.floor((5/9) * (Temperature - 32))).."*C."
		else TemperatureDescription = " Low "..tostring(Temperature).."*F." end
			
		if Temperature > 95 then
			TemperatureDescription = " Hot. "..TemperatureDescription
		elseif Temperature < 25 then
			TemperatureDescription = " Cold. "..TemperatureDescription
		end
		
	end
	
		
	local WindSpeed = math.random(0, 4) * 5
	if Settings.UseMetric.Value then WindDescription = " Winds "..Directions[math.random(1, #Directions)].." at "..tostring(math.floor(WindSpeed * 1.609)).." to "..tostring(math.floor(WindSpeed * 1.609) + 10) .." kph."
	else WindDescription = " Winds "..Directions[math.random(1, #Directions)].." at "..WindSpeed.." to "..WindSpeed + 10 .." mph." end
	
	ChanceDescription = " Chance of precipitation "..Chance.."%."
	
	return WeatherDescription .. TemperatureDescription .. WindDescription .. ChanceDescription
	
end

return Description