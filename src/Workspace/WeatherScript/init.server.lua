print("Redon Tech Weather System: Loading...")

local ToolBar = plugin:CreateToolbar("Redon Tech")
local Button = ToolBar:CreateButton("234354676654", "Install / Update Weather System", "http://www.roblox.com/asset/?id=319050289", "Weather System")
local Mouse = plugin:GetMouse()

local GUI = script.SetupGUI:Clone()
GUI.Parent = game:GetService("CoreGui")

local UIEffects = script.UIEffects
local TweenHighlight = require(UIEffects.TweenHighlight)
local CreateCircle = require(UIEffects.CreateCircle)

local Main = GUI.MainMenu
local Settings = GUI.Settings
local Climate = GUI.Climate
local UninstallConfirm = GUI.UninstallConfirm
local Admin = GUI.Admin
if game.ReplicatedStorage:FindFirstChild("WeatherResources") then WeatherResources = game.ReplicatedStorage.WeatherResources end

local GUIIsVisible = false
local IncludeGUI = true

if game.ReplicatedStorage:FindFirstChild("LoadLibrary") and not game.ServerScriptService:FindFirstChild("WeatherManager") then
	print("Redon Tech Weather System: If this game doesn't have the weather system installed you may remove \"Load Libary\" from Replicated Storage.")
end

wait(1)

local RbxGui = require(script.Systems.LoadLibrary.RbxGui)


print("Redon Tech Weather System: Loaded")

function IsWithinObject(Parent, Mouse)
	if (Mouse.X >= Parent.AbsolutePosition.X and Mouse.X <= Parent.AbsolutePosition.X + Parent.AbsoluteSize.X) and
		(Mouse.Y >= Parent.AbsolutePosition.Y and Mouse.Y <= Parent.AbsolutePosition.Y + Parent.AbsoluteSize.Y) then
		return true
	else return false end
end



local Months = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}
local LockedMonth = nil
local MonthDropDown, updateMonthSelection = RbxGui.CreateDropDownMenu(Months, function(value) WeatherResources.Settings.LockMonth.Value = value end)
MonthDropDown.Name = "MonthDropDown"
MonthDropDown.Position = UDim2.new(0, 270, 0, 230)
MonthDropDown.Size = UDim2.new(0, 230, 0, 40)
MonthDropDown.Parent = Settings
MonthDropDown.Visible = false



local Weathers = {"Sunny", "Partly Cloudy", "Mostly Cloudy", "Cloudy", "Drizzle / Flurries", "Rain / Snow Showers", "Rain / Snow", "Hvy Rain / Snow / TStorms", "Strong Thunderstorms"}

function GetWeatherID(Weather)
	for i = 1, #Weathers do if Weathers[i] == Weather then return i end end
end

local WeatherDropDownLower, WeatherDropDownUpper

local WeatherDropDownLower, updateWeatherLowerSelection = RbxGui.CreateDropDownMenu(Weathers, function(value)
	if GetWeatherID(value) <= WeatherResources.Settings.WeatherBounds.MaxValue then
		WeatherResources.Settings.WeatherBounds.MinValue = GetWeatherID(value)
	else
		WeatherDropDownLower.DropDownMenuButton.Text = Weathers[WeatherResources.Settings.WeatherBounds.MaxValue]
		WeatherResources.Settings.WeatherBounds.MinValue = WeatherResources.Settings.WeatherBounds.MaxValue
	end
end)
WeatherDropDownLower.Name = "WeatherDropDownLower"
WeatherDropDownLower.Position = UDim2.new(0, 0, 0, 110)
WeatherDropDownLower.Size = UDim2.new(0, 240, 0, 40)
WeatherDropDownLower.Parent = Climate.Limits
WeatherDropDownLower.Visible = true

local WeatherDropDownUpper, updateWeatherSelection = RbxGui.CreateDropDownMenu(Weathers, function(value)
	if GetWeatherID(value) >= WeatherResources.Settings.WeatherBounds.MinValue then
		WeatherResources.Settings.WeatherBounds.MaxValue = GetWeatherID(value)
	else
		WeatherDropDownUpper.DropDownMenuButton.Text = Weathers[WeatherResources.Settings.WeatherBounds.MinValue]
		WeatherResources.Settings.WeatherBounds.MaxValue = WeatherResources.Settings.WeatherBounds.MinValue
	end
end)
WeatherDropDownUpper.Name = "WeatherDropDownUpper"
WeatherDropDownUpper.Position = UDim2.new(0, 0, 0, 190)
WeatherDropDownUpper.Size = UDim2.new(0, 240, 0, 40)
WeatherDropDownUpper.Parent = Climate.Limits
WeatherDropDownUpper.Visible = true


function CloseGUI()
	Main.Visible = false
	Settings.Visible = false
	Climate.Visible = false
	UninstallConfirm.Visible = false
	Admin.Visible = false
	GUIIsVisible = false
	plugin:Activate(false)	
end

Button.Click:connect(function()
	GUIIsVisible = not GUIIsVisible
	
	if GUIIsVisible == true then	
		plugin:Activate(true)	
		Main.Visible = true
	else CloseGUI() end
end)

function IsSetUp()
	if game.ReplicatedStorage:FindFirstChild("WeatherResources") and
		game.ServerScriptService:FindFirstChild("WeatherManager") and
		game.StarterPack:FindFirstChild("PlayerSetup") and
		(game.StarterPlayer.StarterPlayerScripts:FindFirstChild("PrecipManager") or game.StarterPlayer.StarterCharacterScripts:FindFirstChild("PrecipManager")) and
		game.ServerStorage:FindFirstChild("TTPPluginAdmins") and
		game.StarterGui:FindFirstChild("Admin") then
		return true
	else
		return false
	end
end



Main.Close.MouseButton1Click:connect(function() CloseGUI() end)

function Uninstall(Directory)
	for _, Child in pairs(Directory:GetChildren()) do
		if Child:FindFirstChild("TTPPluginIdentifier") then if Child.TTPPluginIdentifier.Value == "Weather" then Child:Destroy() end end
	end
end

Main.Install.MouseButton1Click:connect(function()
	
	GUI.MouseClick:Play()
	
	wait(1)
	
	local OldAdmins
	if game.ServerStorage:FindFirstChild("TTPPluginAdmins") then OldAdmins = game.ServerStorage.TTPPluginAdmins:Clone() end
	local OldSettings
	if game.ReplicatedStorage:FindFirstChild("WeatherResources") then
		if game.ReplicatedStorage.WeatherResources:FindFirstChild("Settings") then OldSettings = game.ReplicatedStorage.WeatherResources.Settings:Clone() end
	end
	
	Uninstall(game.ServerScriptService)
	Uninstall(game.ReplicatedStorage)
	Uninstall(game.StarterGui)
	Uninstall(game.StarterPack)
	Uninstall(game.ServerStorage)
	Uninstall(game.StarterPlayer.StarterPlayerScripts) -- Just incase of old systems
	Uninstall(game.StarterPlayer.StarterCharacterScripts)
	
	local Systems = script.Systems
	-- Player Setup
	Systems.PlayerSetup:Clone().Parent = game.StarterPack
	game.StarterPack.PlayerSetup.Disabled = false
	-- Weather Manager
	Systems.WeatherManager:Clone().Parent = game.ServerScriptService
	game.ServerScriptService.WeatherManager.Disabled = false
	game.ServerScriptService.WeatherManager.DaylightManager.Disabled = false
	-- Precip Manager
	Systems.PrecipManager:Clone().Parent = game.StarterPlayer.StarterCharacterScripts
	game.StarterPlayer.StarterCharacterScripts.PrecipManager.Disabled = false
	-- Weather Resources
	Systems.WeatherResources:Clone().Parent = game.ReplicatedStorage
	-- Load Library
	Systems.LoadLibrary:Clone().Parent = game.ReplicatedStorage
	-- Admin
	Systems.Admin:Clone().Parent = game.StarterGui
	game.StarterGui.Admin.WeatherAdmin.Disabled = false
	Systems.WeatherFunction:Clone().Parent = game.ReplicatedStorage
	if not OldAdmins then Systems.TTPPluginAdmins:Clone().Parent = game.ServerStorage end
	WeatherResources = game.ReplicatedStorage.WeatherResources
	
	if OldSettings then
		
		local NewGameSettings = WeatherResources.Settings
		NewGameSettings.Parent = nil
		OldSettings.Parent = WeatherResources
		
		for _, Object in pairs(NewGameSettings:GetChildren()) do
			
			if Object:IsA("Folder") then
				if OldSettings:FindFirstChild(Object.Name) then
					for _, Child in pairs(Object:GetChildren()) do				
						if not OldSettings[Object.Name]:FindFirstChild(Child.Name) then
							Child.Parent = OldSettings[Object.Name]
						end
					end
				else
					Object.Parent = OldSettings
				end
				
			elseif string.find(Object.ClassName, "Value") then
				if not OldSettings:FindFirstChild(Object.Name) then
					Object.Parent = OldSettings
				end
			end
		end
		NewGameSettings:Destroy()
	end	
	
	Main.Error.Visible = false
	Main.UninstallMessage.Visible = false
	Main.InstallMessage.Visible = true
	wait(3)
	Main.InstallMessage.Visible = false
end)

Main.Climate.MouseButton1Click:connect(function()
	
	GUI.MouseClick:Play()
	
	wait(1)
	
	if IsSetUp() then
		Main.Visible = false
		Climate.Visible = true
		
		for _, Month in pairs(Climate.AverageTemps:GetChildren()) do
			if Month.Name ~= "Title" then
				if WeatherResources.Settings.UseMetric.Value then
					Month.High.Text = math.floor((5/9) * (WeatherResources.Settings.AverageTemps[Month.Name].MaxValue - 32))
					Month.Low.Text = math.floor((5/9) * (WeatherResources.Settings.AverageTemps[Month.Name].MinValue - 32))
				else
					Month.High.Text = WeatherResources.Settings.AverageTemps[Month.Name].MaxValue
					Month.Low.Text = WeatherResources.Settings.AverageTemps[Month.Name].MinValue
				end
			end
		end
		
		for _, Season in pairs(Climate.PrecipChances:GetChildren()) do
			if Season.Name ~= "Title" then
				Season.Text = WeatherResources.Settings.AveragePrecip[Season.Name].Value
			end
		end
		
		WeatherDropDownLower.DropDownMenuButton.Text = Weathers[WeatherResources.Settings.WeatherBounds.MinValue]
		WeatherDropDownUpper.DropDownMenuButton.Text = Weathers[WeatherResources.Settings.WeatherBounds.MaxValue]
		
		if WeatherResources.Settings.UseWeatherBounds.Value then
			Climate.Limits.Visible = true
			Climate.PrecipChances.Visible = false
		else
			Climate.Limits.Visible = false
			Climate.PrecipChances.Visible = true
		end
		
	else
		Main.Error.Visible = true
		Main.UninstallMessage.Visible = false
		Main.InstallMessage.Visible = false
		wait(5)
		Main.Error.Visible = false
	end
end)

Main.Settings.MouseButton1Click:connect(function()
	
	GUI.MouseClick:Play()
	
	wait(1)
	
	if IsSetUp() then
		Main.Visible = false
		Settings.Visible = true
		
		Settings.AdminSettings.Visible = WeatherResources.Settings.EnableAdmin.Value
		Settings.EnableAdmin.Check.Visible = WeatherResources.Settings.EnableAdmin.Value
		Settings.EnableDate.Check.Visible = WeatherResources.Settings.EnableDate.Value
		Settings.EnableForecast.Check.Visible = WeatherResources.Settings.EnableForecast.Value
		if WeatherResources.Settings.LockMonth.Value ~= "" then Settings.LockMonth.Check.Visible, MonthDropDown.Visible = true, true
		else Settings.LockMonth.Check.Visible, MonthDropDown.Visible = false, false end
		if WeatherResources.Settings.LockTime.Value ~= "" then Settings.LockTime.Check.Visible, Settings.Time.Visible = true, true
		else Settings.LockTime.Check.Visible, Settings.Time.Visible = false, false end
		Settings.UseImperial.Check.Visible = not WeatherResources.Settings.UseMetric.Value
		Settings.UseMetric.Check.Visible = WeatherResources.Settings.UseMetric.Value
		
	else
		Main.Error.Visible = true
		Main.UninstallMessage.Visible = false
		Main.InstallMessage.Visible = false
		wait(5)
		Main.Error.Visible = false
	end
end)

Main.Uninstall.MouseButton1Click:connect(function()
	GUI.MouseClick:Play()
	Main.Visible = false
	UninstallConfirm.Visible = true
end)



UninstallConfirm.Back.MouseButton1Click:connect(function()
	GUI.MouseClick:Play()
	Main.Visible = true
	UninstallConfirm.Visible = false
end)

UninstallConfirm.Uninstall.MouseButton1Click:connect(function()
	GUI.MouseClick:Play()
	
	wait(1)
	
	Uninstall(game.ServerScriptService)
	Uninstall(game.ReplicatedStorage)
	Uninstall(game.StarterGui)
	Uninstall(game.StarterPack)
	Uninstall(game.StarterPlayer.StarterPlayerScripts) -- Just incase of old systems
	Uninstall(game.StarterPlayer.StarterCharacterScripts)
	
	Main.Visible = true
	UninstallConfirm.Visible = false
	
	Main.Error.Visible = false
	Main.UninstallMessage.Visible = true
	Main.InstallMessage.Visible = false
	wait(3)
	Main.UninstallMessage.Visible = false
end)



Settings.Back.MouseButton1Click:connect(function()
	GUI.MouseClick:Play()
	Main.Visible = true
	Settings.Visible = false
end)

Settings.AdminSettings.MouseButton1Click:connect(function()
	GUI.MouseClick:Play()
	Admin.Visible = true
	Settings.Visible = false
end)

Settings.EnableAdmin.MouseButton1Click:connect(function()
	GUI.MouseClick:Play()
	Settings.EnableAdmin.Check.Visible = not Settings.EnableAdmin.Check.Visible
	Settings.AdminSettings.Visible = Settings.EnableAdmin.Check.Visible
	WeatherResources.Settings.EnableAdmin.Value = Settings.EnableAdmin.Check.Visible
end)

Settings.EnableDate.MouseButton1Click:connect(function()
	GUI.MouseClick:Play()
	if not Settings.EnableDate.GrayOut.Visible then
		Settings.EnableDate.Check.Visible = not Settings.EnableDate.Check.Visible
		WeatherResources.Settings.EnableDate.Value = Settings.EnableDate.Check.Visible
	end
end)

Settings.EnableForecast.MouseButton1Click:connect(function()
	if not Settings.EnableForecast.GrayOut.Visible then
		GUI.MouseClick:Play()
		Settings.EnableForecast.Check.Visible = not Settings.EnableForecast.Check.Visible
		WeatherResources.Settings.EnableForecast.Value = Settings.EnableForecast.Check.Visible
	end
end)

Settings.LockMonth.MouseButton1Click:connect(function()
	if not Settings.LockMonth.GrayOut.Visible then
		GUI.MouseClick:Play()
		Settings.LockMonth.Check.Visible = not Settings.LockMonth.Check.Visible
		if Settings.LockMonth.Check.Visible then WeatherResources.Settings.LockMonth.Value = "January" else WeatherResources.Settings.LockMonth.Value = "" MonthDropDown.DropDownMenuButton.Text = "January" end
		Settings.EnableDate.GrayOut.Visible = Settings.LockMonth.Check.Visible
		Settings.LockTime.GrayOut.Visible = Settings.LockMonth.Check.Visible
		MonthDropDown.Visible = Settings.LockMonth.Check.Visible
	end
end)

Settings.LockTime.MouseButton1Click:connect(function()
	if not Settings.LockTime.GrayOut.Visible then
		GUI.MouseClick:Play()
		Settings.LockTime.Check.Visible = not Settings.LockTime.Check.Visible
		Settings.Time.Visible = Settings.LockTime.Check.Visible
		if Settings.LockTime.Check.Visible then WeatherResources.Settings.LockTime.Value = "12:00" end
		Settings.EnableDate.GrayOut.Visible = Settings.LockTime.Check.Visible
		Settings.EnableForecast.GrayOut.Visible = Settings.LockTime.Check.Visible
		Settings.LockMonth.GrayOut.Visible = Settings.LockTime.Check.Visible
		Settings.LockMonth.Check.Visible = false
		if Settings.LockTime.Check.Visible then WeatherResources.Settings.LockMonth.Value = "January" else WeatherResources.Settings.LockMonth.Value = "" MonthDropDown.DropDownMenuButton.Text = "January" end
		MonthDropDown.Visible = Settings.LockTime.Check.Visible
		if not Settings.LockTime.Check.Visible then WeatherResources.Settings.LockTime.Value = "" end
	end
end)

Settings.UseImperial.MouseButton1Click:connect(function()
	if not Settings.UseImperial.GrayOut.Visible then
		GUI.MouseClick:Play()
		Settings.UseImperial.Check.Visible = not Settings.UseImperial.Check.Visible
		Settings.UseMetric.Check.Visible = not Settings.UseImperial.Check.Visible
		WeatherResources.Settings.UseMetric.Value = Settings.UseMetric.Check.Visible
	end
end)

Settings.UseMetric.MouseButton1Click:connect(function()
	if not Settings.UseMetric.GrayOut.Visible then
		GUI.MouseClick:Play()
		Settings.UseMetric.Check.Visible = not Settings.UseMetric.Check.Visible
		Settings.UseImperial.Check.Visible = not Settings.UseMetric.Check.Visible
		WeatherResources.Settings.UseMetric.Value = Settings.UseMetric.Check.Visible
	end
end)

Settings.Time.Changed:connect(function(Property)
	if Property == "Text" then
		WeatherResources.Settings.LockTime.Value = Settings.Time.Text
	end
end)

for _, Child in pairs(Settings:GetChildren()) do
	Child.MouseEnter:connect(function()
		local Help
		if Child.Name == "EnableAdmin" then
			Help = "Allow in-game weather control for defined administrators."
		elseif Child.Name == "EnableDate" then
			Help = "Show the current date to players.  Automatically disabled when time progression is locked to a month or frozen completely."
		elseif Child.Name == "EnableForecast" then
			Help = "Show the daily forecast to players.  Automatically disabled when time progression is frozen completely."
		elseif Child.Name == "LockMonth" then
			Help = "Lock time to a certain month to garuntee a desired seasonal weather at all times.  Disables date functionality."
		elseif Child.Name == "LockTime" then
			Help = "Freeze time at a defined time of day during a defined month.  Disables date and forecast GUI."
		elseif Child.Name == "UseImperial" or Child.Name == "UseMetric" then
			Help = "Toggle between use of the imperial system (MPH, *F) and the metric system (KPH, *C)."
		end
		if Help then
			Settings.Help.Text = Help
			Move = Mouse.Move:connect(function()
				if not IsWithinObject(Child, Mouse) then
					Move:disconnect()
					Settings.Help.Text = ""
				end
			end)
		end
	end)
end



Climate.Back.MouseButton1Click:connect(function()
	GUI.MouseClick:Play()
	Main.Visible = true
	Climate.Visible = false
end)

Climate.LimitWeather.MouseButton1Click:connect(function()
	GUI.MouseClick:Play()
	Climate.LimitWeather.Check.Visible = not Climate.LimitWeather.Check.Visible
	Climate.PrecipChances.Visible = not Climate.LimitWeather.Check.Visible
	Climate.Limits.Visible = Climate.LimitWeather.Check.Visible
	WeatherResources.Settings.UseWeatherBounds.Value = Climate.LimitWeather.Check.Visible
end)

for _, Button in pairs(Climate.PrecipChances:GetChildren()) do
	Button.Changed:connect(function(Property)
		if Property == "Text" and tonumber(Button.Text) then
			WeatherResources.Settings.AveragePrecip[Button.Name].Value = math.floor(tonumber(Button.Text))
		end
	end)
end

for _, Button in pairs(Climate.AverageTemps:GetChildren()) do
	if Button.Name ~= "Title" then
		Button.Low.Changed:connect(function(Property)
			if Property == "Text" and tonumber(Button.Low.Text) then
				WeatherResources.Settings.AverageTemps[Button.Name].MinValue = math.floor(tonumber(Button.Low.Text))
			end
		end)
		Button.High.Changed:connect(function(Property)
			if Property == "Text" and tonumber(Button.High.Text) then
				WeatherResources.Settings.AverageTemps[Button.Name].MaxValue = math.floor(tonumber(Button.High.Text))
			end
		end)
	end
end



local CurrentAdmin

function DisplayAdmin()
	local Child = game.ServerStorage.TTPPluginAdmins:GetChildren()
	for i = 1, 24 do
		Admin.AdminButtons["Button"..i].TextColor3 = Color3.new(1,1,1)
		Admin.AdminButtons["Button"..i].BackgroundColor3 = Color3.new(1,1,1)
		if Child[i] ~= nil then Admin.AdminButtons["Button"..i].Text = Child[i].Name
		else Admin.AdminButtons["Button"..i].Text = "" end
	end
end

Admin.Changed:connect(function(Property)
	if Property == "Visible" and Admin.Visible == true then
		if not game.ServerStorage:FindFirstChild("TTPPluginAdmins") then
			local Folder = Instance.new("Folder")
			Folder.Name = "TTPPluginAdmins"
			Folder.Parent = game.ServerStorage
		end
		DisplayAdmin()
	end
end)

for _, Button in pairs(Admin.AdminButtons:GetChildren()) do
	Button.MouseButton1Click:connect(function()
		for _, Button2 in pairs(Admin.AdminButtons:GetChildren()) do if string.find(Button2.Name, "Button") ~= nil then Button2.BackgroundColor3 = Color3.new(1,1,1) end end
		Button.BackgroundColor3 = Color3.new(0,1,1)
		CurrentAdmin = Button.Text
	end)
end

for _, Button in pairs(Admin:GetChildren()) do
	if Button:IsA("TextButton") then
		Button.MouseButton1Click:connect(function()
			if Button.Name == "RemoveAdmin" then
				GUI.MouseClick:Play()
				if game.ServerStorage.TTPPluginAdmins:FindFirstChild(CurrentAdmin) then
					game.ServerStorage.TTPPluginAdmins:FindFirstChild(CurrentAdmin):Destroy()
				end
				DisplayAdmin()
			elseif Button.Name == "Add" then
				GUI.MouseClick:Play()
				local StringValue = Instance.new("StringValue")
				StringValue.Name = Admin.TextBox.Text
				StringValue.Parent = game.ServerStorage.TTPPluginAdmins
				DisplayAdmin()
			elseif Button.Name == "Back" then
				GUI.MouseClick:Play()
				Admin.Visible = false
				Settings.Visible = true
			end
		end)
	elseif Button.Name == "Hotkey" then
		Button.Changed:connect(function(Property)
			if Property == "Text" then
				if string.len(Button.Text) > 0 then
					WeatherResources.Settings.AdminHotKey.Value = string.sub(Button.Text, string.len(Button.Text))
					Button.Text = string.sub(Button.Text, string.len(Button.Text))
				end
			end
		end)
	end
end


Main.Close.MouseEnter:connect(function() TweenHighlight(Main.Close, UDim2.new(0,50,1,0), UDim2.new(1,0,1,0), Mouse) end)
Main.Climate.MouseEnter:connect(function() TweenHighlight(Main.Climate, UDim2.new(0,50,1,0), UDim2.new(1,0,1,0), Mouse) end)
Main.Settings.MouseEnter:connect(function() TweenHighlight(Main.Settings, UDim2.new(0,50,1,0), UDim2.new(1,0,1,0), Mouse) end)
Main.Uninstall.MouseEnter:connect(function() TweenHighlight(Main.Uninstall, UDim2.new(0,50,1,0), UDim2.new(1,0,1,0), Mouse) end)
Main.Install.MouseEnter:connect(function() TweenHighlight(Main.Install, UDim2.new(0,50,1,0), UDim2.new(1,0,1,0), Mouse) end)
Settings.Back.MouseEnter:connect(function() TweenHighlight(Settings.Back, UDim2.new(0,35,1,0), UDim2.new(1,0,1,0), Mouse) end)
Settings.AdminSettings.MouseEnter:connect(function() TweenHighlight(Settings.AdminSettings, UDim2.new(0,40,1,0), UDim2.new(1,0,1,0), Mouse) end)
Climate.Back.MouseEnter:connect(function() TweenHighlight(Climate.Back, UDim2.new(0,40,1,0), UDim2.new(1,0,1,0), Mouse) end)
UninstallConfirm.Back.MouseEnter:connect(function() TweenHighlight(UninstallConfirm.Back, UDim2.new(0,50,1,0), UDim2.new(1,0,1,0), Mouse) end)
UninstallConfirm.Uninstall.MouseEnter:connect(function() TweenHighlight(UninstallConfirm.Uninstall, UDim2.new(0,50,1,0), UDim2.new(1,0,1,0), Mouse) end)
Admin.Back.MouseEnter:connect(function() TweenHighlight(Admin.Back, UDim2.new(0,35,1,0), UDim2.new(1,0,1,0), Mouse) end)
Admin.Add.MouseEnter:connect(function() TweenHighlight(Admin.Add, UDim2.new(0,30,1,0), UDim2.new(1,0,1,0), Mouse) end)
Admin.RemoveAdmin.MouseEnter:connect(function() TweenHighlight(Admin.RemoveAdmin, UDim2.new(0,30,1,0), UDim2.new(1,0,1,0), Mouse) end)