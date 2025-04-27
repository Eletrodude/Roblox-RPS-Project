--[[
Title: [M1 Handler]
Description: [Handles M1's and their interactions with the world.]
Author: [Eletrodude]
Date: [31/3/2025]
--]]
-- SERVICES
-- (Game services like Players, DataStoreService, ReplicatedStorage, etc.)
local ServerScriptService = game:GetService('ServerScriptService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local GenerateService = game:GetService('GenerationService')


-- MODULES
-- (Require any external modules or scripts)
local JumpModule  = require(game:GetService('ServerScriptService').Modules.CombatModules.Jump)
local Attributes = require(ServerScriptService.Modules.AuxilliaryModules.AttributeModule)
local HitboxModule = require(ServerScriptService.Modules.CombatModules.Hitbox)
local DamageModule = require(ServerScriptService.Modules.CombatModules.DealDamage)
local Config = require(ServerScriptService.Infos.CombatConfiguration)
local Ragdoll = require(ServerScriptService.Modules.CombatModules.Ragdoll)
local Ragdoll_2 = require(ServerScriptService.Modules.CombatModules["Ragdoll(Mid)"])
local Ragdoll_3 = require(ServerScriptService.Modules.CombatModules["Ragdoll(Imported)"])
local KnockBack = require(ServerScriptService.Modules.CombatModules.KnockBack)
local Maid = require(ServerScriptService.Modules.CoreModules.Maid)
local PlaySound = require(ServerScriptService.Modules.AuxilliaryModules.PlaySound)



-- VARIABLES
-- (Local variables that store data or references)
local PlayersTable = {}
local EventsFolder = ReplicatedStorage.Remotes
local M1Event = EventsFolder.UniversalCombat.M1
local BlockEvent = EventsFolder.UniversalCombat.Block
local SoundEvent = EventsFolder.Auxilliary.SoundEvent
local KnockBackVelocity = 1
local CooldownVar = Config.M1.Cooldown.Normal
local FinalCooldownVar =  Config.M1.Cooldown.Final

local SoundFolder = game:GetService('ServerStorage').GlobalSounds
local HitSoundEffect = SoundFolder.Effects.HitSound
local Slam = SoundFolder.Effects.Downslam
local Kick = SoundFolder.Effects.Kick
local Whoosh = SoundFolder.Effects.Whoosh
local Block = SoundFolder.Effects.BlockHit

-- CONSTANTS
-- (Values that do not change throughout the script)
local RagdollCooldown = 2



-- FUNCTIONS	
-- (Define reusable functions here)

local function CheckCounter(Player:Player)
	local OldCounter = PlayersTable[Player.UserId].Counter
	local Character:Model = Player.Character::Model
	task.wait(1)
	if PlayersTable[Player.UserId].Counter == OldCounter then 
		PlayersTable[Player.UserId].Counter = 0
		Character:SetAttribute('Counter',0) 
		M1Event:FireClient(Player,'Reset')
	end

end



local function HandleHitbox(PlrTable,Player:Player,Size,HitboxPosition,Debris,Mode,HitboxIgnore,Visualizer,Keyword)
	local Character = Player.Character::Model
	
	local DamageMultiplier = Character:GetAttribute('DamageMultiplier')
	
	
	local DamageAmount = (PlrTable.Counter == 4) and Config.M1.Damage.Final or  Config.M1.Damage.Normal
	local ShouldDoKnockBack = (PlrTable.Counter == 4)
	local RagdollDuration = Config.Ragdoll.DefaultDuration
	local Direction = Config.M1.Knockback.Forward
	local Multiplier = Config.M1.Knockback.Force
	local KnockbackDuration = Config.M1.Knockback.Duration
	
	
		

		local Hitbox 
		
		if Character:GetAttribute('Counter') == 4 and Keyword == 'Downslam' then 
		Hitbox = HitboxModule:SpacialQuery(Player,Vector3.new(Size.X,12,Size.Y),HitboxPosition,Debris,1,nil,true)
		else
		Hitbox = HitboxModule:SpacialQuery(Player,Size,HitboxPosition,Debris,1,nil,true)
		end
		
		

		if Hitbox[1] then 
			for Index,CharactersHit:Model in pairs(Hitbox) do 
	

				if CharactersHit:GetAttribute('IsBlocking') == true then 
					--Play block sound noob
					--Fire VFX for block
					
					local HumanoidRootPart = Character:FindFirstChild('HumanoidRootPart')::BasePart
					local EnemyHumRootPart = CharactersHit:FindFirstChild('HumanoidRootPart')::BasePart
					
					local Look = EnemyHumRootPart.CFrame.LookVector
					local DirectionDef = (HumanoidRootPart.Position-EnemyHumRootPart.Position).Unit
					
					local Dot = Look:Dot(DirectionDef)
					
					if Dot > 0.5 then 
						print('Facing Defender')
						local Sound = Block:Clone()
						Sound.Parent = CharactersHit
						Sound.RollOffMode = Enum.RollOffMode.Inverse
						Sound.RollOffMinDistance = 10
						Sound.RollOffMaxDistance = 100
						PlaySound.PlaySoundGlobal(Player,Sound)
						
						return
					else
						local PlayerHit = game.Players:GetPlayerFromCharacter(CharactersHit)
						print('Not facing')
						CharactersHit:SetAttribute('IsBlocking',false)
						BlockEvent:FireClient(PlayerHit)
						
					end
										
					 
				end
				
				
				
				DamageModule:InflictDamage({
					Damage = DamageAmount,
					Character = Character,
					EnemyCharacter = CharactersHit,
					DamageType = 1
					
					
					
				})
				
				
				local Sound 
				
				
				if ShouldDoKnockBack and Keyword == 'Downslam' then
				Sound = Slam:Clone()
				Sound.Parent = CharactersHit
				Sound.RollOffMode = Enum.RollOffMode.Inverse
				Sound.RollOffMinDistance = 10
				Sound.RollOffMaxDistance = 100
				PlaySound.PlaySoundGlobal(Player,Sound)
				
				
				task.spawn(function()
					task.wait(Sound.TimeLength)
					Sound:Destroy()
				end)
					
					
					
				task.spawn(function()
					KnockBack.KnockBackEnemy(Character,CharactersHit,Vector3.new(0,1,0),30,0.2)
					--Ragdoll.RagdollPlayer(CharactersHit,3)
					Ragdoll_3.Start(CharactersHit)
					task.wait(RagdollCooldown)
					Ragdoll_3.Stop(CharactersHit)
				end)
				elseif ShouldDoKnockBack then 
				
				Sound = Kick:Clone()
				Sound.Parent = CharactersHit
				Sound.RollOffMode = Enum.RollOffMode.Inverse
				Sound.RollOffMinDistance = 10
				Sound.RollOffMaxDistance = 100
				PlaySound.PlaySoundGlobal(Player,Sound)

				
				task.spawn(function()
					task.wait(Sound.TimeLength)
					Sound:Destroy()
				end)
					
				task.spawn(function()
					KnockBack.KnockBackEnemy(Character,CharactersHit,Direction,Multiplier,KnockbackDuration)
					Ragdoll_3.Start(CharactersHit)
					task.wait(RagdollCooldown)
					Ragdoll_3.Stop(CharactersHit)
				end)
				
				
				
					
				else
				Sound = HitSoundEffect:Clone()
				Sound.Parent = CharactersHit
				Sound.RollOffMode = Enum.RollOffMode.Inverse
				Sound.RollOffMinDistance = 10
				Sound.RollOffMaxDistance = 100
				PlaySound.PlaySoundGlobal(Player,Sound)

				task.spawn(function()
					task.wait(Sound.TimeLength+1)
					Sound:Destroy()
				end)
				
				
				end
				--DealDamage:Destroy()
			end
		end
	
end



local function HandleM1s(Player:Player,Keyword:string)
	local CombatData = PlayersTable[Player.UserId]
	local Character = Player.Character::Model
	
	local Counter = CombatData.Counter
	--print(Counter)
	local FinalHit = 4
	
	local Cooldown = (Counter == FinalHit) and Config.M1.Cooldown.Final or Config.M1.Cooldown.Normal
	
	local Humanoid:Humanoid = Character:FindFirstChildWhichIsA('Humanoid')::Humanoid

	local HumanoidRootPart = Character:FindFirstChild('HumanoidRootPart')::BasePart
	local Size = Config.M1.Hitbox.Size
	local HumPos = HumanoidRootPart.CFrame
	local HitboxPosition = HumPos * Config.M1.Hitbox.Offset
	local Debris = 0.3
	
	JumpModule:Cooldowns(Player,0.6)
	
	
	HandleHitbox(CombatData,Player,Size,HitboxPosition,0.3,Config.DamageTypes.SingleHit,nil,true,Keyword,Counter)
	--print(Cooldown)
	
	local Sound = Whoosh:Clone()
	Sound.RollOffMode = Enum.RollOffMode.Inverse
	Sound.RollOffMinDistance = 10
	Sound.RollOffMaxDistance = 100
	Sound.Parent = Character
	PlaySound.PlaySoundGlobal(Player,Sound)
	game.Debris:AddItem(Sound,Sound.TimeLength+0.1)
	
	
	
	
	CombatData.Cooldown = true
	task.delay(Cooldown,function()
		if Counter == FinalHit then 
		
			
			PlayersTable[Player.UserId].Counter = 0
			Character:SetAttribute('Counter',0)
			PlayersTable[Player.UserId].Cooldown = false
			task.spawn(function()
				CheckCounter(Player)
				
			end)
			
			
		elseif PlayersTable[Player.UserId].Counter < 4 then 
			
			PlayersTable[Player.UserId].Cooldown = false
			
			task.spawn(function()
				CheckCounter(Player)
			end)
			
		end
	end)
	
	
	
	
end



	


-- MAIN SCRIPT LOGIC
-- (Core script execution and function calls)
-- HANDLERS
-- (Event listeners and connections)
M1Event.OnServerEvent:Connect(function(Player,Keyword)
	
	if not Player then
		warn('Invalid Player')
		return
	end
	
	if not Player.Character then
		warn('No Character found!')
		return
	end
	
	
	local Character = Player.Character
	
	if not Player.Character:FindFirstChildWhichIsA('Humanoid') then 
		warn('Humanoid invalid')
		return 
	end
	
	
	local State,Attribute = Attributes.CheckAttributes(Player,nil,nil,nil)
	
	if State == false and Attribute ~= 'Contienue' then 
		warn('A(n) attribute(s) is equal to true! Now returning')
		M1Event:FireClient(Player,'Stop')
		return
	end
	
	if not PlayersTable[Player.UserId] then
		PlayersTable[Player.UserId] = {
			Cooldown = false,
			Counter = 0,
			MaidInstance = Maid.new(),
		}
	end
		
	if PlayersTable[Player.UserId].Cooldown == true then 
		warn('Cooldown active!')
		M1Event:FireClient(Player)
		return
	end
	
	
	
	
	
	if PlayersTable[Player.UserId].MaidInstance == nil then
		PlayersTable[Player.UserId].MaidInstance = Maid.new()
	end
	
	
	local PlrTable = PlayersTable[Player.UserId]
	
	
	PlrTable.Counter +=1
	Character:SetAttribute('Counter',PlrTable.Counter)
	
		
	---------------------------------------------

	
	
	HandleM1s(Player,Keyword)
	
	
	
	
	
	
end)



game.Players.PlayerAdded:Connect(function(Player)
	Player.CharacterRemoving:Connect(function()
		PlayersTable[Player.UserId].MaidInstance:DoCleaning()
		PlayersTable[Player.UserId] = nil
	end)
end)


-- ERROR HANDLING
-- (pcall or other error-handling mechanisms)


