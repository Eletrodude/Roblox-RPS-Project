--!strict 

--Title: [Client Dash Script]
--Description: [Short description of what this script does]
--Author: [Eletrodude]
--Date: [10/03/2025]

-- SERVICES
-- (Game services like Players, DataStoreService, ReplicatedStorage, etc.)
local PlayerService = game:GetService("Players")
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServerScriptService = game:GetService('ServerScriptService')
local TweenService = game:GetService('TweenService')
local RunService = game:GetService('RunService')
local ContextActionService = game:GetService('ContextActionService')
local UIS = game:GetService('UserInputService')

-- MODULES
-- (Require any external modules or scripts)
local AtributeHandler = require(ReplicatedStorage:WaitForChild('Modules'):WaitForChild('CoreModule(Client)'):WaitForChild('AttributeModule'))
-- VARIABLES
-- (Local variables that store data or references)
local Debounce = false
local Player:Player = PlayerService.LocalPlayer::Player 
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChildWhichIsA('Humanoid')
local HumanoidRootPart:BasePart = Character:WaitForChild('HumanoidRootPart',10)::BasePart

local DashEvent = ReplicatedStorage:WaitForChild('Remotes'):WaitForChild('UniversalCombat'):WaitForChild('Dash')

-- CONSTANTS
-- (Values that do not change throughout the script)
local DashConfig = {
	['Forward'] = {HumanoidRootPart.CFrame.LookVector},
	['Left'] = {-HumanoidRootPart.CFrame.RightVector},
	['Down'] = {-HumanoidRootPart.CFrame.LookVector},
	['Right'] = {HumanoidRootPart.CFrame.RightVector}
}

-- FUNCTIONS
-- (Define reusable functions here)


local function DashDirection():string
	if UIS:IsKeyDown(Enum.KeyCode.W) then 
		return 'Forward'
	elseif UIS:IsKeyDown(Enum.KeyCode.A) then
		return 'Left'
	elseif UIS:IsKeyDown(Enum.KeyCode.S) then 
		return 'Down'
	elseif UIS:IsKeyDown(Enum.KeyCode.D) then 
		return 'Right'
	end
	return 'Forward'
end



local function OnDash(Action: string, State: Enum.UserInputState, input: Enum.KeyCode)
	if State == Enum.UserInputState.Begin and Debounce == false then
		if AtributeHandler.CheckAttributes(Player) == false then 
			warn('Invalid Attribute')
			return
		end
		Debounce = true
		
		assert(HumanoidRootPart,'HMR not found')
		
		local Direction = DashDirection()
	
		local DirectionVector:Vector3
		
		if Direction == 'Forward'  then
			DirectionVector = HumanoidRootPart.CFrame.LookVector
		elseif Direction == 'Left' then 
			DirectionVector = -HumanoidRootPart.CFrame.RightVector
		elseif Direction == 'Down' then 
			DirectionVector = -HumanoidRootPart.CFrame.LookVector
		elseif Direction == 'Right' then
			DirectionVector = HumanoidRootPart.CFrame.RightVector
		end
		
		
		DashEvent:FireServer(Direction)
		
		
	end
end
-- MAIN SCRIPT LOGIC
-- (Core script execution and function calls)
ContextActionService:BindAction('Dash',OnDash,false,Enum.KeyCode.Q)
-- HANDLERS
-- (Event listeners and connections)
DashEvent.OnClientEvent:Connect(function()
	Debounce = false
end)

-- ERROR HANDLING
-- (pcall or other error-handling mechanisms)
