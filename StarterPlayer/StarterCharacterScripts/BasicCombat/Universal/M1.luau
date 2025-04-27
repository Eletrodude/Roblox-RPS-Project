--[[
Title: [Mouse Button 1 ]
Description: [Allows users to attack with mousebutton 1]
Author: [Eletrodude]
Date: [25/03/2025]
--]]
-- SERVICES
-- (Game services like Players, DataStoreService, ReplicatedStorage, etc.)
local ContextActionService = game:GetService('ContextActionService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserInputService = game:GetService('UserInputService')
local ContentProvider = game:GetService('ContentProvider')
local PlayerService = game:GetService('Players')

-- MODULES
-- (Require any external modules or scripts)
local Maid = require(ReplicatedStorage.Modules["CoreModule(Client)"].Maid)
local AtrChecker = require(ReplicatedStorage.Modules["CoreModule(Client)"].AttributeModule)
-- VARIABLES
-- (Local variables that store data or references)
local Player = PlayerService.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChildWhichIsA('Humanoid')
local Animator = Humanoid:FindFirstChildWhichIsA('Animator')
local Counter = 0
local M1Debounce = false


-- CONSTANTS
-- (Values that do not change throughout the script)
local M1Event = ReplicatedStorage:WaitForChild('Remotes').UniversalCombat.M1
local AnimFolder = ReplicatedStorage.GlobalAnimations
local Connection
local Animation
local Track
local CounterCooldown = 0.4
local FinalM1Cooldown  = 2
local MaxCounter = 4

-- FUNCTIONS
-- (Define reusable functions here)

local AnimationsTable = {AnimFolder.Sequence1,AnimFolder.Sequence2,AnimFolder.Sequence3,
	AnimFolder.Sequence4,AnimFolder.Downslam
}


for index,value in ipairs(AnimationsTable) do 
	ContentProvider:PreloadAsync({value})
end


local function CycleThroughAnimations(Counter,otherAnimation:string)
	
	if not otherAnimation then
		Animation = AnimationsTable[Counter]
		
		
		
		Track = Animator:LoadAnimation(Animation)
		Track:Play(0.2,1,1)
	
	elseif otherAnimation == 'Downslam' then 
		Animation = AnimationsTable[5]
		Track = Animator:LoadAnimation(Animation)
		Track:Play(0.2,1,1)
	end
end




--local function CheckCounter()
--	local OldCounter = Counter
--		task.wait(1)
		
--		if OldCounter == Counter  then 
--			print('Counter is the same')
--			Counter = 0
--		end
	
--end


local function onM1(name, state, input)
	
	if state == Enum.UserInputState.Begin and M1Debounce == false then
		
		if AtrChecker.CheckAttributes(Player,false) == false then 
			return
		end
		
		
		if Humanoid.Health == 0  then
			return
		end
		
		if AtrChecker.CheckAttributes(Player) == false then 
			warn('Attributes false, now returning')
			return
		end
		
		M1Debounce = true
		Counter = Counter + 1
		
		if Counter == MaxCounter and Humanoid:GetState() == Enum.HumanoidStateType.Freefall then 
			CycleThroughAnimations(Counter,'Downslam')
			M1Event:FireServer('Downslam')
			task.delay(FinalM1Cooldown,function()
				M1Debounce = false
				Counter = 0 
			end)
			
		elseif Counter == MaxCounter then 
			CycleThroughAnimations(Counter)
			M1Event:FireServer()
			task.delay(FinalM1Cooldown,function()
				M1Debounce = false
				Counter = 0 
			end)
			
		
		elseif Counter ~= MaxCounter then 
			CycleThroughAnimations(Counter)
			
			M1Event:FireServer()
			task.delay(CounterCooldown,function()
				M1Debounce = false
			end)
			
		end
		
		
		
	end
end
-- MAIN SCRIPT LOGIC
-- (Core script execution and function calls)
Humanoid.Died:Connect(function()
	Track:Stop()
	Track:Destroy()
end)



ContextActionService:BindAction('M1',onM1,false,Enum.UserInputType.MouseButton1)
-- HANDLERS
-- (Event listeners and connections)
M1Event.OnClientEvent:Connect(function(String,Sound)
	if Track and Track.IsPlaying and String == 'Stop' then
		Track:Stop()
		
	elseif String == 'Reset' then 
		Counter = 0
		
	end
	
end)


-- ERROR HANDLING
-- (pcall or other error-handling mechanisms)
