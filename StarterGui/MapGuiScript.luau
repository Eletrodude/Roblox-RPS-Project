--!strict
--[[
Title: [ChooseMapGui]
Description: [Short description of what this script does]
Author: [Eletrodude]
Date: [12/03/2025]
--]]

-- SERVICES
-- (Game services like Players, DataStoreService, ReplicatedStorage, etc.)
local TweenService = game:GetService('TweenService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')


-- VARIABLES
-- (Local variables that store data or references)
local ScreenGui = script.Parent
local Frame = ScreenGui.Frame
local MapText = Frame.MapSizeTextBox
local Conncetion 


-- CONSTANTS
-- (Values that do not change throughout the script)
local MapSizeEvent = ReplicatedStorage.Remotes.Auxilliary.MapSizeEvent
local Ignore = {'LargeMapShadow','MediumMapShadow','SmallMapShadow'}
local Properties1 = {ImageTransparency = 0,BackgroundTransparency = 1}
local Properties2 = {TextTransparency = 0}
local ConnectionTable = {}

-- MODULES
-- (Require any external modules or scripts)
local Maid


-- FUNCTIONS
-- (Define reusable functions here)

local function CheckIgnore(v)
	for index,Value in pairs(Ignore) do 
		if v.Name == Value then
			return true
		end
	end
	return false
end



local function EnableGui(Text)
	if Text == 'EnableGui' then
		ScreenGui.ViewportFrame.Visible =false
		ScreenGui.Enabled = true
		
		local TweenInformation = TweenInfo.new(0.5,Enum.EasingStyle.Linear)
		
		local Tween1 = TweenService:Create(MapText,TweenInformation,{TextTransparency = 0})
		
		Tween1:Play()
		
		Tween1.Completed:Connect(function()
			
			for _,values in pairs(Frame:GetDescendants()) do 
				if CheckIgnore(values) == true then continue end
				
			
				if values:IsA('ImageButton')  then
					local Tween2 = TweenService:Create(values,TweenInformation,Properties1)
					Tween2:Play()
					
				elseif values:IsA('TextBox') then
					local Tween2 = TweenService:Create(values,TweenInformation,Properties2)
					Tween2:Play()
				end 
			end
		end)
	
	
	end
	
	if Conncetion then
		task.wait(2)
		Conncetion:Disconnect()
	end
	
end

local function OnHover(ImageButton:ImageButton)
	local TweenInformation = TweenInfo.new(0.1,Enum.EasingStyle.Linear)
	local Tween = TweenService:Create(ImageButton,TweenInformation,{ImageTransparency = 0.8})
	Tween:Play()
end

local function OnHoverEnd(ImageButton:ImageButton)
	local TweenInformation = TweenInfo.new(0.1,Enum.EasingStyle.Linear)
	local Tween = TweenService:Create(ImageButton,TweenInformation,{ImageTransparency = 1})
	Tween:Play()
end

function DisconnectAllConnections()
	for _, connection in ipairs(ConnectionTable) do
		connection:Disconnect()
	end
	-- Clear the ConnectionTable to ensure no references remain
	table.clear(ConnectionTable)
end

-- MAIN SCRIPT LOGIC
-- (Core script execution and function calls)


-- HANDLERS
-- (Event listeners and connections)
Conncetion = MapSizeEvent.OnClientEvent:Connect(EnableGui)



-- HANDLERS
-- (Event listeners and connections)

-- Mouse enter and mouse leave events for SmallMapShadow
table.insert(ConnectionTable, Frame.SmallMapShadow.MouseEnter:Connect(function()
	OnHover(Frame.SmallMapShadow)
end))

table.insert(ConnectionTable, Frame.SmallMapShadow.MouseLeave:Connect(function()
	OnHoverEnd(Frame.SmallMapShadow)
end))

-- Mouse enter and mouse leave events for MediumMapShadow
table.insert(ConnectionTable, Frame.MediumMapShadow.MouseEnter:Connect(function()
	OnHover(Frame.MediumMapShadow)
end))

table.insert(ConnectionTable, Frame.MediumMapShadow.MouseLeave:Connect(function()
	OnHoverEnd(Frame.MediumMapShadow)
end))

-- Mouse enter and mouse leave events for LargeMapShadow
table.insert(ConnectionTable, Frame.LargeMapShadow.MouseEnter:Connect(function()
	OnHover(Frame.LargeMapShadow)
end))

table.insert(ConnectionTable, Frame.LargeMapShadow.MouseLeave:Connect(function()
	OnHoverEnd(Frame.LargeMapShadow)
end))

-- MouseButton1Click events for SmallMapShadow
table.insert(ConnectionTable, Frame.SmallMapShadow.MouseButton1Click:Once(function()
	Frame.Visible = false
	MapSizeEvent:FireServer('Small')
	DisconnectAllConnections()
end))

-- MouseButton1Click events for MediumMapShadow
table.insert(ConnectionTable, Frame.MediumMapShadow.MouseButton1Click:Once(function()
	Frame.Visible = false
	MapSizeEvent:FireServer('Medium')
	DisconnectAllConnections()

end))

-- MouseButton1Click events for LargeMapShadow
table.insert(ConnectionTable, Frame.LargeMapShadow.MouseButton1Click:Once(function()
	Frame.Visible = false
	MapSizeEvent:FireServer('Large')
	DisconnectAllConnections()

end))

-- Connect the EnableGui function
Conncetion = MapSizeEvent.OnClientEvent:Connect(EnableGui)

-- Cleanup function to disconnect all connections



-- ERROR HANDLING
-- (pcall or other error-handling mechanisms)