--!strict
--[[
--[[export type DealDamageScript = {Player:Player,DamageType:number,
--	InflictDamage: (self:DealDamage,Damage:number,Multi_Hit_Amount:number,Duration:number,DamageDelay:number) ->nil
--}


--local DealDamage = {}



--DealDamage.__index = DealDamage

----[[
--DamageType1:Single-hit damage
--DamageType2:Multi-hit damage
--DamageType3:Percentage based Damage

--
--function DealDamage.new(Character:Model,EnemyCharacter:Model,DamageType:number) :DealDamageScript
--	local self = setmetatable({},DealDamage)
	
--	if (not EnemyCharacter or not EnemyCharacter:IsA('Model'))  then
--		warn("Enemy Player not found")
--		return
--	end
	
--	if not Character or not Character:IsA('Model') then 
--		warn('Player has not been found or invalid')
--		return
--	end
	
	
--	if not DamageType then 
--		DamageType = 1
--	end
	
--	self.Character = Character
	
--	self.EnemyCharacter = EnemyCharacter
	
--	self.DamageType = DamageType
	
--	return self
	
--end

----[[
--Damage Types:
--1 = Single-hit:Only the Damage Parameter is needed,alongside the true damage. 
--2 = Multi-hit: Requires a table with the given parameters: MultiHitAmount,DamageDelay
--3 = Percentage: Deals a percentage based amount of damage,ignores defense.
--4 = Multi-hit Percentage: Deals a damage percentage based dot effect,ignores defense. Requires same parameters as 2.
--5 = True Damage: Basically 1, but ignores ALL defenses, dealing the total amount of damage.
--]]
--function DealDamage:InflictDamage(Damage,AlternativeInformation) :{Instance}?
--	local EnemyCharacter:Model = self.EnemyCharacter
--	local Character:Model = self.Character
--	local DamageType = self.DamageType
		
--	if not EnemyCharacter then 
--		warn('Character not Found')
--		return 
--	end
	
	
	
--	if EnemyCharacter:GetAttribute('IsInvincible') == true  or  EnemyCharacter:GetAttribute('CanBeDamaged') == false then
--		warn('Character is unable to be Damaged!')
--		return
--	end
	
	
--	local Humanoid = EnemyCharacter:FindFirstChildWhichIsA('Humanoid')
	
	
--	if not Humanoid then
--		warn('Humanoid not found')
--		return
--	end
	
--	local MultiHitAmount
--	local Duration
--	local DamageDelay
	
	
--	if DamageType ~= 5  then 
--		local DamageMult = Character:GetAttribute('DamageMultiplier') or 1
--		local DefensiveMult = EnemyCharacter:GetAttribute('DefenseMultiplier') or 1
--		DefensiveMult = math.max(DefensiveMult,0.75)
		
		
		
		
--		local FinalDamage = (Damage*DamageMult)/DefensiveMult
		
--		if FinalDamage < 1 then 
--			warn('Damage being increased to the minimum: 1')
--			FinalDamage = math.max(1,FinalDamage)
--		elseif FinalDamage > 50 then 
--			warn('Damage being reduced from :',FinalDamage,' to 50!')
--			FinalDamage = math.min(50,FinalDamage)
--		end
		
		
		
--		print(FinalDamage)
		
		
--		Damage = FinalDamage
		
--	end
	
	
	
--	if DamageType == 2 or DamageType == 4 then 
--		MultiHitAmount = AlternativeInformation.MultiHitAmount
--		DamageDelay = AlternativeInformation.DamageDelay
--		Duration = AlternativeInformation.Duration
	
--	end
	
--	if DamageType == 1 then 		
--		DealDamageOnce(Humanoid,Damage)
--	elseif DamageType == 2 then 
--		task.spawn(function()
--			DamageOverTime(Humanoid,Damage,MultiHitAmount,DamageDelay)
--		end)
--	elseif DamageType ==  3 then
--	PercentageBasedDamage(Humanoid,Damage)
--	elseif DamageType == 4 then 
--		PercentageBasedMultiHit(Humanoid,Damage,MultiHitAmount,DamageDelay)
--	elseif DamageType == 5 then 
--		TrueDamage(Humanoid,Damage)
--	end
--end



--function DealDamageOnce(Humanoid,Damage)
--	Humanoid:TakeDamage(Damage)
--end

--function DamageOverTime(Humanoid,Damage,Times,DamageDelay)
--	for i = 1, Times do
--		Humanoid:TakeDamage(Damage)
--		task.wait(DamageDelay)
--	end
--end

--function PercentageBasedDamage(Humanoid,DamagePercentage)
--	local Damage = Humanoid.MaxHealth * DamagePercentage
--	Humanoid:TakeDamage(Damage)
	
--end

--function PercentageBasedMultiHit(Humanoid,DamagePercentage,Times,DamageDelay)
--	local Damage = Humanoid.MaxHealth * DamagePercentage
	
--	for i = 1,Times do 
--		task.wait(DamageDelay)
--		Humanoid:TakeDamage(Damage)
--	end
	
--end

--function TrueDamage(Humanoid,Damage)
--	Humanoid:TakeDamage(Damage)
--end


--function DealDamage:Destroy()
--	self.Character = nil
--	self.EnemyCharacter = nil
--	self.DamageType = nil
--	setmetatable(self, nil) -- Clear metatable for cleanup
--end



--]]return DealDamage

--]]

--!strict

export type DamageSettings = {
	
	Damage:number,
	Character:Model,
	EnemyCharacter:Model,
	DamageType:number,
	
	--Multihit parameters
	MultiHitAmount:number?,--Number of hits
	Duration:number?,
	DamageDelay:number?
}


local DealDamage = {}

local Config = {MaxDamage = 50, MinDamage = 1}
local DamageHandlers = {
	[1] = DealDamageOnce,
	[2] = DamageOverTime,
	[3] = PercentageBasedDamage,
	[4] = PercentageBasedMultiHit,
	[5] = TrueDamage
}



--[[
DamageType1:Single-hit damage
DamageType2:Multi-hit damage
DamageType3:Percentage based Damage

]]


--[[
Damage Types:
1 = Single-hit:Only the Damage Parameter is needed,alongside the true damage. 
2 = Multi-hit: Requires a table with the given parameters: MultiHitAmount,DamageDelay
3 = Percentage: Deals a percentage based amount of damage,ignores defense.
4 = Multi-hit Percentage: Deals a damage percentage based dot effect,ignores defense. Requires same parameters as 2.
5 = True Damage: Basically 1, but ignores ALL defenses, dealing the total amount of damage.
]]
function DealDamage:InflictDamage(SettingsTable:{Damage:number,Character:Model,EnemyCharacter:Model,DamageType:number?,MultiHitAmount:number?,DamageDelay:number?,Duration:number?} ) 
	local Damage = SettingsTable.Damage::number
	local Character = SettingsTable.Character::Model
	local EnemyCharacter = SettingsTable.EnemyCharacter::Model
	local DamageType = SettingsTable.DamageType::number

	local MultiHitAmount:number? = SettingsTable.MultiHitAmount::number?
	local DamageDelay:number? = SettingsTable.DamageDelay::number?
	local Duration:number? = SettingsTable.Duration::number?

	if not EnemyCharacter then 
		warn('Character not Found')
		return 
	end



	if EnemyCharacter:GetAttribute('IsInvincible') == true  or  EnemyCharacter:GetAttribute('CanBeDamaged') == false then
		warn('Character is unable to be Damaged!')
		return
	end


	local Humanoid = EnemyCharacter:FindFirstChildWhichIsA('Humanoid')::Humanoid


	if not Humanoid then
		warn('Humanoid not found')
		return
	end

	
	local FinalDamage
	
	--Damage type 5 is true damage, so need to check for defenses.
	if DamageType ~= 5  then 
		local DamageMult:number = Character:GetAttribute('DamageMultiplier') or 1
		local DefensiveMult:number = EnemyCharacter:GetAttribute('DefenseMultiplier') or 1
		DefensiveMult = math.max(DefensiveMult,0.75)




		local FinalDamage = (Damage*DamageMult)/DefensiveMult

		if FinalDamage < 1 then 
			warn('Damage being increased to the minimum: 1')
			FinalDamage = math.max(Config.MinDamage,FinalDamage)
		elseif FinalDamage > 50 then 
			warn('Damage being reduced from :',FinalDamage,' to 50!')
			FinalDamage = math.min(Config.MaxDamage,FinalDamage)
		end



		print(FinalDamage)


		Damage = FinalDamage

	end

	local Handler = DamageHandlers[DamageType]
	
	if DamageType == 1 then 		
		DealDamageOnce(Humanoid,Damage)
		
	elseif DamageType == 2 then 
		task.spawn(function()
			DamageOverTime(Humanoid,Damage,MultiHitAmount::number,DamageDelay)
		end)
		
	elseif DamageType ==  3 then
		PercentageBasedDamage(Humanoid,Damage)
		
	elseif DamageType == 4 then 
		PercentageBasedMultiHit(Humanoid,Damage,MultiHitAmount::number,DamageDelay)
		
	elseif DamageType == 5 then 
		TrueDamage(Humanoid,Damage)
		
	end

	
	
end



function DealDamageOnce(Humanoid,Damage)
	Humanoid:TakeDamage(Damage)
end

function DamageOverTime(Humanoid,Damage,Times,DamageDelay)
	for i = 1, Times do
		Humanoid:TakeDamage(Damage)
		task.wait(DamageDelay)
	end
end

function PercentageBasedDamage(Humanoid,DamagePercentage)
	local Damage = Humanoid.MaxHealth * DamagePercentage
	Humanoid:TakeDamage(Damage)

end

function PercentageBasedMultiHit(Humanoid,DamagePercentage,Times,DamageDelay)
	local Damage = Humanoid.MaxHealth * DamagePercentage

	for i = 1,Times do 
		task.wait(DamageDelay)
		Humanoid:TakeDamage(Damage)
	end

end

function TrueDamage(Humanoid,Damage)
	Humanoid:TakeDamage(Damage)
end





return DealDamage