--!strict 

--Title: [Dash]
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

-- MODULES
-- (Require any external modules or scripts)
local AttributeHandler = require(ServerScriptService.Modules.AuxilliaryModules.AttributeModule)
local Config = require(ServerScriptService.Infos.CombatConfiguration)
local TimeManager = require(ServerScriptService.Infos.TimeManager)
-- VARIABLES
-- (Local variables that store data or references)
local DashEvent = ReplicatedStorage.Remotes.UniversalCombat.Dash

-- CONSTANTS
-- (Values that do not change throughout the script)
local DataTable:{[number]:{BodyVelocity:BodyVelocity?,Connection:RBXScriptConnection?}} = {}
local DashDuration = 0.3
local DashCooldown = 3

-- FUNCTIONS
-- (Define reusable functions here)
local function EnableDash(Player:Player,DirectionValue:string)
	if not Player then 
		assert(Player,'Player Not Found')
	end
	
	if not DirectionValue then 
		assert(DirectionValue,'Direction Not Found')
	end
	
	local Character:Model = Player.Character::Model
	
	if not Character then 
		assert(Character,'Character not found!')
	end
	
	local HumanoidRootPart:BasePart = Character:FindFirstChild('HumanoidRootPart')::BasePart
	
	if not HumanoidRootPart then 
		assert(HumanoidRootPart,'HumanoidRootPart not found')
	end
	
	local PlayerData = DataTable[Player.UserId]
	
	local BodyVelocity = Instance.new('BodyVelocity')
	BodyVelocity.MaxForce = Vector3.new(1,0,1) * 1000000
	
	local DirectionVector:Vector3
	
	
	
	if DirectionValue == 'Forward' then 
		DirectionVector =  HumanoidRootPart.CFrame.LookVector 
	elseif DirectionValue == 'Down' then 
		DirectionVector =  -HumanoidRootPart.CFrame.LookVector 	
	elseif DirectionValue == 'Left' then 
		DirectionVector =  -HumanoidRootPart.CFrame.RightVector 
	elseif DirectionValue == 'Right' then 
		DirectionVector =  HumanoidRootPart.CFrame.RightVector
	end
	
	BodyVelocity.Velocity = DirectionVector + Vector3.new(0,0,-100)
	BodyVelocity.Parent = HumanoidRootPart
	
	
	PlayerData.BodyVelocity = BodyVelocity
	
	local EndTimeDash = os.clock() + DashDuration
	local EndTimeCooldown = os.clock() + DashCooldown
	game.Debris:AddItem(BodyVelocity,DashDuration)
	
	task.delay(DashDuration,function()
		AttributeHandler:ModifyAttributes(Player,'IsDashing',false)

	end)
	
	PlayerData.Connection = RunService.Heartbeat:Connect(function(DT)
		if os.clock() >= EndTimeCooldown then 
			PlayerData.Connection:Disconnect()
			PlayerData.Connection = nil
			DashEvent:FireClient(Player)
			
		end
		
	end)
	
end

local function OnDied(Player:Player)
	if DataTable[Player.UserId].Connection then 
		DataTable[Player.UserId].Connection:Disconnect()
		DataTable[Player.UserId].Connection = nil
		DataTable[Player.UserId].BodyVelocity:Destroy()
	end
end
-- MAIN SCRIPT LOGIC
-- (Core script execution and function calls)
DashEvent.OnServerEvent:Connect(function(Player:Player,Direction:string)
	if not Player then 
		assert(Player,'Not found')
	end
	
	local Character = Player.Character
	
	if not Character then 
		assert(Character,'Not found')
	end
	
	if AttributeHandler.CheckAttributes(Player) == false then 
		warn('Cannot Dash because Attributes true')
		return
	end
	
	if not DataTable[Player.UserId] then 
		DataTable[Player.UserId] = {
			BodyVelocity = nil,
			Connection = nil}
	end
	
	
	if TimeManager:IsCooldownReady(Player,'Dash') == true then 
		TimeManager:StartCooldown(Player,'Dash',DashCooldown)
		EnableDash(Player,Direction)
		AttributeHandler:ModifyAttributes(Player,'IsDashing',true)
	end
	
	
	local Humanoid:Humanoid = Character:FindFirstChildWhichIsA('Humanoid')::Humanoid
	
	Humanoid.Died:Connect(function()
		print('ded')
	end)
	
	
end)






-- HANDLERS
-- (Event listeners and connections)
-- ERROR HANDLING
-- (pcall or other error-handling mechanisms)
