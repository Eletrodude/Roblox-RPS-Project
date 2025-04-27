----!strict
--local Attributes = {}
--Attributes.__index = Attributes

--function Attributes.new(Player,AttributesTable)
--	local self = setmetatable({},Attributes)
	
--	if not Player or not Player:IsA('Player') then
--		warn('Player not found')
--		return
--	end
	
--	if not AttributesTable  then
--		AttributesTable = {}
--	end
	
--	self.Player = Player
--	self.AttributesTable = AttributesTable

--	return self
	
--end


--function Attributes:DisableStats()
--	local Player:Player = self.Player

--	local Character = Player.Character
	
--	if not Character then
--		warn('Character not found')
--		return
--	end
		
--	local Humanoid = Character:FindFirstChildWhichIsA('Humanoid')
	
--	if not Humanoid then
--		warn('Humanoid not Found')
--		return
--	end
	
--	local WalkSpeed = 0
--	local JumpHeight = 0
--	local JumpPower = 0
	
--	Humanoid.WalkSpeed = WalkSpeed
--	Character:SetAttribute('WalkSpeed',WalkSpeed)
--	Humanoid.JumpPower = 0
--	Character:SetAttribute('JumpPower',JumpPower)
--	Humanoid.JumpHeight = JumpHeight
--	Character:SetAttribute('JumpHeight',JumpHeight)

	

--end

--function Attributes:EnableStats()
--	local Player:Player = self.Player

--	local Character = Player.Character

--	if not Character then
--		warn('Character not found')
--		return
--	end

--	local Humanoid = Character:FindFirstChildWhichIsA('Humanoid')

--	if not Humanoid then
--		warn('Humanoid not Found')
--		return
--	end


--	local WalkSpeed = Character:GetAttribute('BaseWalkSpeed') or 16
--	local JumpHeight = Character:GetAttribute('BaseJumpHeight') or 50
--	local JumpPower = Character:GetAttribute('BaseJumpPower') or 7.3

--	Humanoid.WalkSpeed = WalkSpeed
--	Character:SetAttribute('WalkSpeed',WalkSpeed)
--	Humanoid.JumpPower = JumpPower
--	Character:SetAttribute('JumpPower',JumpPower)
--	Humanoid.JumpHeight = JumpHeight
--	Character:SetAttribute('JumpHeight',JumpHeight)


--end


--function Attributes:ModifyAttributes()
--	local Player = self.Player
	
--	local Character:Model = Player.Character
--	if not Character then
--		warn('Character not found')
--		return
--	end
--	local Humanoid = Character:FindFirstChildWhichIsA('Humanoid')
--	if not Humanoid then
--		warn('Humanoid not Found')
--		return
--	end
--	for i,v in pairs(self.AttributesTable) do
--		Humanoid:SetAttribute(i,v)
--	end
	
	
	
--end


--function Attributes.CheckAttributes(Player:Player,eventToStopTrack:RemoteEvent?,AttributeTable:{string}?,Ignore:string?):boolean
--	local ReturnBool
	
--	if not Player or not Player:IsA('Player') then
--		warn('Player not found')
--		return false
--	end
	
	
--	local Character = Player.Character
	
--	if not Character then 
--		warn('Character not found')
--		return false
--	end
	
--	local AttributesTable = AttributeTable or  {'IsAttacking','IsBlocking','IsStunned','IsDashing'}
	
--	for index,value in pairs(AttributesTable) do 
--		if Ignore then continue end
--		if Character:GetAttribute(value) == true   then
			
--			--if Character:GetAttribute('InCombat') == false then
--			--	return false
--			--end
--			if eventToStopTrack then
--				eventToStopTrack:FireClient(Player,'StopTrack')
--			end
			
--			return false
--		end
		
--		return true
--	end
	
	
	
--	return false
	
--end




--return Attributes


--!strict

export type Stats = {[string]:number|boolean}
export type ConfigType = {[string]:Stats}

local Attributes = {}

--local Config:ConfigType = {
--	Blocking = {WalkSpeed = 4,JumpPower = 0,JumpHeight = 0} ,
--	Dashing = {}
--} 

local ConfigMod = require(game:GetService('ServerScriptService').Infos.CombatConfiguration)
local Config = ConfigMod.Block.Attributes

function Attributes:DisableStats(Player:Player)
	local Character = Player.Character

	if not Character then
		warn('Character not found')
		return
	end

	local Humanoid = Character:FindFirstChildWhichIsA('Humanoid')

	if not Humanoid then
		warn('Humanoid not Found')
		return
	end

	local WalkSpeed = 0
	local JumpHeight = 0
	local JumpPower = 0

	Humanoid.WalkSpeed = WalkSpeed
	Character:SetAttribute('WalkSpeed',WalkSpeed)
	Humanoid.JumpPower = 0
	Character:SetAttribute('JumpPower',JumpPower)
	Humanoid.JumpHeight = JumpHeight
	Character:SetAttribute('JumpHeight',JumpHeight)



end

function Attributes:ModifyStats(Player:Player,StatTable:{[string]:number|string|boolean}?,Type:string)
	if not Player then 
		warn('Player not found!')
		return
	end
	
	local Character = Player.Character
	
	if not Character then 
		warn('Character not found!')
		return
	end
	
	
	if not StatTable  and not Type then 
		warn('Invalid Stats')
		return
	end
	
	if StatTable then
		for Stats,Values in StatTable do 
			Character:SetAttribute(Stats,Values)
		end
	elseif Type == 'Block' then 
		for Stats,Values in Config do 
			print(Stats,Values)
			Character:SetAttribute(Stats,Values)
		end
	elseif Type == 'Default' then 
		Attributes:EnableStats(Player)
	end
end


function Attributes:EnableStats(Player:Player)
	local Character = Player.Character

	if not Character then
		warn('Character not found')
		return
	end

	local Humanoid = Character:FindFirstChildWhichIsA('Humanoid')

	if not Humanoid then
		warn('Humanoid not Found')
		return
	end


	local WalkSpeed = Character:GetAttribute('BaseWalkSpeed') or 16
	local JumpHeight = Character:GetAttribute('BaseJumpHeight') or 50
	local JumpPower = Character:GetAttribute('BaseJumpPower') or 7.3

	Humanoid.WalkSpeed = WalkSpeed
	Character:SetAttribute('WalkSpeed',WalkSpeed)
	Humanoid.JumpPower = JumpPower
	Character:SetAttribute('JumpPower',JumpPower)
	Humanoid.JumpHeight = JumpHeight
	Character:SetAttribute('JumpHeight',JumpHeight)


end


function Attributes:ModifyAttributes(Player:Player,Attribute:string,Value:string|boolean|number)


	local Character:Model = Player.Character::Model
	if not Character then
		warn('Character not found')
		return
	end

	if not Attribute or type(Attribute) ~= 'string' then 
		warn('Attribute invalid or not found: ',Attribute)
		return
	end
	
	if not Value  then 
		if type(Value) == 'string' or type(Value) == 'number' or type(Value) == 'boolean' then 
			
		else
			warn('Value invalid or nil: ',Value)

			return
		end
		
	end
	
	print('Reached the moon')
	
	
	
	Character:SetAttribute(Attribute,Value)
	
	if type(Value) ~= "string" then 
		
	end
	
	print('Modifying '..Attribute..'to: '..tostring(Value))
	
	
	
	

end


function Attributes.CheckAttributes(Player:Player,eventToStopTrack:RemoteEvent?,AttributeTable:{string}?,Ignore:string?):(boolean,string)
	local ReturnBool

	if not Player or not Player:IsA('Player') then
		warn('Player not found')
		return false,'nil'
	end


	local Character = Player.Character

	if not Character then 
		warn('Character not found')
		return false,'nil'
	end

	warn(AttributeTable)

	local AttributesTable = AttributeTable or  {'IsAttacking','IsBlocking','IsStunned','IsDashing'}

	for index,value in pairs(AttributesTable) do 
		--warn(value)
		if Ignore == value then
			continue 
			
		end
		if Character:GetAttribute(value) == true   then

			--if Character:GetAttribute('InCombat') == false then
			--	return false
			--end
			if eventToStopTrack then
				eventToStopTrack:FireClient(Player,'StopTrack')
			end
			
			warn(value)
			return false,value
			
			
		end

		
	end



	return true,'Continue'

end




return Attributes

