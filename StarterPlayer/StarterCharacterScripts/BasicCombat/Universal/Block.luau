--!strict
--[[
Title: [Your Script Title]
Description: [Short description of what this script does]
Author: [Eletrodude]
Date: [10/03/2025]
--]]
-- SERVICES
-- (Game services like Players, DataStoreService, ReplicatedStorage, etc.)
local ContextActionService = game:GetService('ContextActionService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserInputService = game:GetService('UserInputService')
local PlayerService = game:GetService('Players')
-- MODULES
-- (Require any external modules or scripts)
local Maid = require(ReplicatedStorage.Modules["CoreModule(Client)"].Maid)
local AtrChecker = require(ReplicatedStorage.Modules["CoreModule(Client)"].AttributeModule)
-- VARIABLES
-- (Local variables that store data or references)
local Player:Player = PlayerService.LocalPlayer::Player
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild('Humanoid')
local Animator:Animator = Humanoid:WaitForChild('Animator')::Animator
local Animation  = Instance.new('Animation')
Animation.AnimationId = 'rbxassetid://111893932512215'
local Track = Animator:LoadAnimation(Animation)
Track.Looped = true

local BlockDebounce = false
local BlockState = false

-- CONSTANTS
-- (Values that do not change throughout the script)
local BlockEvent = ReplicatedStorage:WaitForChild('Remotes'):WaitForChild('UniversalCombat'):WaitForChild('Block')
local BlockDelay = 0.5
-- FUNCTIONS
-- (Define reusable functions here)
function OnBlock(actionName, inputState, inputObject)
	if inputState == Enum.UserInputState.Begin and BlockDebounce == false then 
		
		if AtrChecker.CheckAttributes(Player,nil,nil,'IsBlocking') == false then 
			return
		end
		
		
		BlockDebounce = true
		BlockState = true
		BlockEvent:FireServer(BlockState)
		print('Blocking')
		Track:Play()
		
	end
	
	if inputState == Enum.UserInputState.End then 
		BlockState = false
		BlockEvent:FireServer(BlockState)
		Track:Stop()
		task.spawn(function()
			task.wait(BlockDelay)
			BlockDebounce = false
		end)
		
	end
	
end
-- MAIN SCRIPT LOGIC
-- (Core script execution and function calls)
ContextActionService:BindAction('Block',OnBlock,false,Enum.KeyCode.F)
-- HANDLERS
-- (Event listeners and connections)

BlockEvent.OnClientEvent:Connect(function()
	if Track.IsPlaying then 
		Track:Stop()
	end
end)
-- ERROR HANDLING
-- (pcall or other error-handling mechanisms)
