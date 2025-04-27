--!strict
local ServerScriptService = game:GetService('ServerScriptService')
local CombatConfig = require(ServerScriptService.Infos.CombatConfiguration)

local ActiveCooldowns = {}


local TimeManager = {}




function TimeManager:StartCooldown(Player:Player,SkillName:string,CooldownTime:number)
	
	if not ActiveCooldowns[Player.UserId] then 
		ActiveCooldowns[Player.UserId] = {}
	end
	

	ActiveCooldowns[Player.UserId][SkillName] = os.clock()+CooldownTime
	print("Cooldown set for " .. Player.Name .. " - " .. SkillName .. ": " .. ActiveCooldowns[Player.UserId][SkillName])
end

function TimeManager:IsCooldownReady(Player:Player,SkillName:string):boolean
	local PlayerCooldowns = ActiveCooldowns[Player.UserId]

	if not PlayerCooldowns then 
		return true
	end

	
	
	--The skill in question that's been used.
	local SkillUsed:number = PlayerCooldowns[SkillName]
	
	--The time to compare
	local CurrentTime = os.clock()
	
	--Checks if skill has been used
	if not SkillUsed then 
		return true
	end
	
	--Checks is the cooldown over
	if CurrentTime >= SkillUsed then 
		PlayerCooldowns[SkillName] = nil
		
		if next(PlayerCooldowns) == nil then
			ActiveCooldowns[Player.UserId] = nil
		end
		return true
	end
	
	--If it reaches this point, then the cooldown is still active
	return false
end


function TimeManager:ResetAllCooldowns(Player:Player)
	ActiveCooldowns[Player.UserId] = nil
end

return TimeManager