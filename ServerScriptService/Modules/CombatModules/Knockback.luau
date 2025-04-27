--!strict
local KnockBackModule = {}

KnockBackModule.KnockBackEnemy = function(Character:Model,EnemyHit:Model,Direction:Vector3,VelocityMult:number,Duration:number)
	if not Character or not Character:IsA('Model') then 
		warn('No Character or invalid')
		return
	end
	
	if not EnemyHit or not EnemyHit:IsA('Model') then 
		warn('Enemy not found or invalid')
		return
	end
	

	if  typeof(Direction) == 'CFrame' then
		Direction = Vector3.new(Direction.CFrame.X,Direction.CFrame.Y,Direction.CFrame.Z)
		
	elseif not Direction then
		Direction = Vector3.new(0,0,-1)
	end
	
	local CharacterHumRootPart = Character:FindFirstChild('HumanoidRootPart')::BasePart
	local HumanoidRootPart = EnemyHit:FindFirstChild('HumanoidRootPart')

	if VelocityMult == 0 or nil then 
		VelocityMult = 10
	end
	
	local velocityDirection = CharacterHumRootPart.CFrame:VectorToWorldSpace(Direction) 
	
	local BodyVelocity = Instance.new('BodyVelocity')
	BodyVelocity.MaxForce = Vector3.new(1,1,1) * 50000000
	BodyVelocity.Velocity = -velocityDirection * VelocityMult	
	BodyVelocity.Parent = HumanoidRootPart
	
	game.Debris:AddItem(BodyVelocity,Duration)

end

KnockBackModule.MoveSelf = function(Character:Model,Direction:Vector3,VelocityMult:number,Duration:number)
	if not Character or not Character:IsA('Model') then
		warn('No Character or invalid')
		return
	end
	
	if not Direction then
		Direction = Vector3.new(0,0,-1)
	end
	local CharacterHumRootPart = Character:FindFirstChild('HumanoidRootPart')::BasePart
	if VelocityMult == 0 or nil then
		VelocityMult = 10
	end
	
	local CharacterHumRootPart = Character:FindFirstChild('HumanoidRootPart')::BasePart
	local velocityDirection = CharacterHumRootPart.CFrame:VectorToWorldSpace(Direction) 
	
	local BodyVelocity = Instance.new('BodyVelocity')	
	BodyVelocity.MaxForce = Vector3.new(1,1,1) * 50000000
	BodyVelocity.Velocity = -velocityDirection * VelocityMult
	BodyVelocity.Parent = CharacterHumRootPart
	game.Debris:AddItem(BodyVelocity,Duration)
	
	
end


function KnockBackModule.Send_Enemy_Flying(Character:Model,EnemyCharacter:Model,Direction:Vector3,VelocityMult:number,Upvector:number,Duration:number)
	if not Character or not Character:IsA('Model') then 
		warn('Character nil or not found')
		return
	end	
	
	if not EnemyCharacter or not EnemyCharacter:IsA('Model') then 
		warn('Not found or nil')
		return
	end
	
	if typeof(Direction) == 'CFrame' then 
		Direction = Vector3.new(Direction.CFrame.X,Direction.CFrame.Y,Direction.CFrame.Z)
	elseif not Direction then
		Direction = Vector3.new(0,1,-1)
	end
	
	local CharacterHumRootPart = Character:FindFirstChild('HumanoidRootPart')::BasePart
	local HumanoidRootPart = EnemyCharacter:FindFirstChild('HumanoidRootPart')::BasePart
	
	if VelocityMult == 0 or nil then
		VelocityMult = 10
	end
	
	if not Upvector or type(Upvector) ~= 'number' then
		Upvector = 40
	end
	
	
	local velocityDirection = CharacterHumRootPart.CFrame:VectorToWorldSpace(Direction)
	local BodyVelocity = Instance.new('BodyVelocity')
	BodyVelocity.MaxForce = Vector3.new(1,1,1) * 5000000;
	BodyVelocity.Velocity = (-velocityDirection * VelocityMult) + (CharacterHumRootPart.CFrame.UpVector * Upvector )
	BodyVelocity.Parent = HumanoidRootPart
	
	game.Debris:AddItem(BodyVelocity,Duration)
	
end


return KnockBackModule