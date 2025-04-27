--!strict
--[[
Title: [Gui Button]
Description: [Button]

--]]
-- SERVICES
-- (Game services like Players, DataStoreService, ReplicatedStorage, etc.)
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local TweenService = game:GetService('TweenService')
local tweenInfo = TweenInfo.new(0.05,Enum.EasingStyle.Linear)
-- MODULES
-- (Require any external modules or scripts)
local SliderModule = ReplicatedStorage:WaitForChild('Modules'):WaitForChild('SliderModule')
local Slider = require(SliderModule)
-- VARIABLES
-- (Local variables that store data or references)
local SettingsEvent = ReplicatedStorage:WaitForChild('Remotes'):WaitForChild('Auxilliary'):WaitForChild('SettingsEvent')
-- CONSTANTS
-- (Values that do not change throughout the script)
local StarterGui = script.Parent
local SettingsFrame = StarterGui:WaitForChild('SettingsFrame')

local boolTable = {}

-- FUNCTIONS
-- (Define reusable functions here)
local connections = {}

local IgnoreTable = {'RenderDistance','Effects'}







local function AddButtonDynamicaly()
	
	for index, value in pairs(SettingsFrame:GetDescendants()) do 
		
		if value.Name == 'SmallText' and value:IsA('TextLabel') and value.Parent.Parent.Name ~='Audio' then 
			value.Size = UDim2.new(0.6,0,0.5,0)
			value.Position = UDim2.new(0.3,0,0.75,0)
			value.TextSize = 40
		end
		
		if value.Name == 'Audio' then 
			for i,v in pairs(value:GetChildren()) do
				
				
				if v:IsA('Frame') and v.Parent.Name == 'Audio' then 
					local SliderFrame = value:FindFirstChild('MasterVolume'):FindFirstChild('SliderFrame'):FindFirstChild('SliderFrame')::Frame
					
					
					
					if v.Name == 'MasterVolume' then
						local Drag = SliderFrame:FindFirstChild('Drag')::Frame
						local HundredPercent = 311
						local DragStoppedEvent = Instance.new("BindableEvent")
						
						local LastPos = Drag.Position.X.Offset
						local IsMoving = false
						local DetectionDelay = 0.2
						
						local function CheckIfDragStopped()
							local CurrentPosition = Drag.Position.X.Offset
							local Percentage = (CurrentPosition / HundredPercent) * 100

							if CurrentPosition ~= LastPos then
								-- Movement detected
								IsMoving = true
								LastPos = CurrentPosition
							elseif IsMoving then
								-- No movement detected but was moving before
								IsMoving = false
								DragStoppedEvent:Fire(Percentage)
							end
						end
						
						Drag:GetPropertyChangedSignal('Position'):Connect(function()
							
							task.spawn(function()
								task.wait(DetectionDelay)
								CheckIfDragStopped()
							end)

							
							
						end)
						
						DragStoppedEvent.Event:Connect(function(FinalPercentage)
							SettingsEvent:FireServer('Audio','MasterVolume',FinalPercentage)
						end)
						
						
						
						continue
					end
					
					
					local Clone = SliderFrame.Parent:Clone()
					local Drag = Clone:FindFirstChild('SliderFrame'):FindFirstChild('Drag')::Frame
					local HundredPercent = 311
					local DragStoppedEvent = Instance.new("BindableEvent")

					local LastPos = Drag.Position.X.Offset
					local IsMoving = false
					local DetectionDelay = 0.2

					local function CheckIfDragStopped()
						local CurrentPosition = Drag.Position.X.Offset
						local Percentage = (CurrentPosition / HundredPercent) * 100

						if CurrentPosition ~= LastPos then
							-- Movement detected
							IsMoving = true
							LastPos = CurrentPosition
							print("Moving: " .. Percentage .. "%")
						elseif IsMoving then
							-- No movement detected but was moving before
							IsMoving = false
							print("Stopped at: " .. Percentage .. "%")
							DragStoppedEvent:Fire(Percentage)
						end
					end

					Drag:GetPropertyChangedSignal('Position'):Connect(function()

						task.spawn(function()
							task.wait(DetectionDelay)
							CheckIfDragStopped()
						end)



					end)

					DragStoppedEvent.Event:Connect(function(FinalPercentage)
						SettingsEvent:FireServer('Audio',Clone.Parent.Name,FinalPercentage)
					end)

					Clone.Parent = v
					
				end
			end
			
			
			
			
		end
		
		
		if value.Name == 'SliderButton' and value:IsA('TextButton') then
			local Button = value
			local Slider = Button.Parent:FindFirstChild('Slider')::ImageLabel
			local SliderButton = Button.Parent:FindFirstChild('Button')

			if not boolTable[Button] then
				boolTable[Button] = {Button, false}
			end

			
			
			

		local Connection = 	Button.MouseButton1Click:Connect(function()
				boolTable[Button][2] = not boolTable[Button][2]
				SettingsEvent:FireServer(Button.Parent.Parent.Parent.Name,Button.Parent.Parent.Name,boolTable[Button][2])
				if boolTable[Button][2] == true then
					TweenService:Create(Slider, tweenInfo, {BackgroundColor3 = Color3.new(0.333333, 1, 0)}):Play()
					TweenService:Create(SliderButton, tweenInfo, {Position = UDim2.new(0.8, 0, 0.5, 0)}):Play()
				else
					TweenService:Create(Slider, tweenInfo, {BackgroundColor3 = Color3.new(1, 0, 0)}):Play()
					TweenService:Create(SliderButton, tweenInfo, {Position = UDim2.new(0.32, 0, 0.5, 0)}):Play()
				end
			end)
		table.insert(connections,Connection)
		elseif value:IsA('TextLabel') and value.Parent:IsA('Frame') then
			
			local Button = SettingsFrame.Template.ButtonFrame

			if not value.Parent:FindFirstChild('ButtonFrame') and value.Parent.Parent.Name~='Audio' then 
				if value.Parent.Name == (IgnoreTable[1] or IgnoreTable[2]) then continue end
				
				
				
				local Clone = Button:Clone()
				Clone.Visible = true
				Clone.Parent = value.Parent

				-- Add additional configuration for the cloned button
				local SliderButton = Clone:FindFirstChild('Button')
				local Slider = Clone:FindFirstChild('Slider')
				local SliderButtonClick = Clone:FindFirstChild('SliderButton')

				-- Ensure initial state is set
				if SliderButton and Slider and SliderButtonClick then
					-- You might want to add initial configuration here
					SliderButton.Position = UDim2.new(0.32, 0, 0.5, 0)
					Slider.BackgroundColor3 = Color3.new(1, 0, 0)
					
					if not boolTable[SliderButtonClick] then
						boolTable[SliderButtonClick] = {SliderButtonClick, false}
					end	
					-- Add click event to the cloned button
					local Connection = 	SliderButtonClick.MouseButton1Click:Connect(function()
						-- Toggle logic similar to the previous section
						local currentState = boolTable[SliderButtonClick] and boolTable[SliderButtonClick][2] or false
						currentState = not currentState
						SettingsEvent:FireServer(Clone.Parent.Parent.Name,Clone.Parent.Name,currentState)

						boolTable[SliderButtonClick] = {SliderButtonClick, currentState}

						if currentState then
							TweenService:Create(Slider, tweenInfo, {BackgroundColor3 = Color3.new(0.333333, 1, 0)}):Play()
							TweenService:Create(SliderButton, tweenInfo, {Position = UDim2.new(0.8, 0, 0.5, 0)}):Play()
						else
							TweenService:Create(Slider, tweenInfo, {BackgroundColor3 = Color3.new(1, 0, 0)}):Play()
							TweenService:Create(SliderButton, tweenInfo, {Position = UDim2.new(0.32, 0, 0.5, 0)}):Play()
						end
					end)
					table.insert(connections,Connection)

				end
			end
			
		end
	end
	
	return SettingsFrame
end

local function FindUiElement(Category:string,CategoryName)
	--print(Category,CategoryName)
	local Frame = SettingsFrame:FindFirstChild(Category)
	
	
	if Frame then
		local SettingsFrame = Frame:FindFirstChild(CategoryName)

		if SettingsFrame then 
			return SettingsFrame
		end
	end
end

-- MAIN SCRIPT LOGIC
-- (Core script execution and function calls)
AddButtonDynamicaly()
-- HANDLERS
-- (Event listeners and connections)
game.Players.PlayerAdded:Connect(function(Player)
	Player.CharacterRemoving:Connect(function()
		for index,value in pairs(connections) do 
			value:Disconnect()
		end
	end)
end)

SettingsEvent.OnClientEvent:Connect(function(SettingsTable)
	-- Iterate through each category in settings
	for Category, CategoryValue in SettingsTable do 
		-- Iterate through each setting in the category
		for SettingName, SettingValue in CategoryValue do 

			task.spawn(function()
				local SettingsFrame = FindUiElement(Category, SettingName)

				if not SettingsFrame then 
					return -- Skip if frame not found
				end

				-- Handle standard toggle settings (non-Audio)
				if SettingValue == true and SettingsFrame.Parent.Name ~= 'Audio' then
					local ButtonFrame = SettingsFrame:FindFirstChild('ButtonFrame')

					if ButtonFrame then 
						local SliderButton = ButtonFrame:FindFirstChild('SliderButton')
						local Slider = ButtonFrame:FindFirstChild('Slider')
						local Button = ButtonFrame:FindFirstChild('Button')

						-- Update the bool table with category value
						boolTable[SliderButton][2] = CategoryValue

						-- Update UI elements
						Slider.BackgroundColor3 = Color3.new(0.333333, 1, 0) -- Green color
						Button.Position = UDim2.new(0.8, 0, 0.5, 0) -- Moved to "on" position

						task.delay(5, function()
						end)
					end
				end

				-- Handle Audio settings specifically
				if SettingsFrame.Parent.Name == 'Audio' then 
					-- Find and update the drag handle
					for _, Value in pairs(SettingsFrame:GetDescendants()) do 
						if Value.Name == 'Drag' then
							local DragFrame = Value :: Frame

							-- Calculate position based on setting value
							-- Keep Y offset the same, only change X
							DragFrame.Position = UDim2.new(
								0, 
								(SettingValue/100)*311, 
								0, 
								DragFrame.Position.Y.Offset
							)
						end
					end
				end
			end)
		end
	end
end)


-- ERROR HANDLING
-- (pcall or other error-handling mechanisms)
