--!strict
local RagdollModule = {}

function RagdollModule.RagdollCharacter(Character:Model,ragdollDuration:number)
	if not Character or not Character:IsA('Model') then
		warn("Character not found or invalid")
		return
	end
	
	if not ragdollDuration then 
		ragdollDuration = 3
	end
	
	local TableOFMotor6Ds = {}
	local TableofDeletionValues = {}
	
	for _,limbs in pairs(Character:GetChildren()) do
		
		if limbs:FindFirstChildWhichIsA('Motor6D') then
			limbs:FindFirstChildWhichIsA('Motor6D').Enabled = false
			table.insert(TableOFMotor6Ds,limbs:FindFirstChildWhichIsA('Motor6D'))
			
			local BallSocketConstraint = Instance.new('BallSocketConstraint')
			local At0,At1 = Instance.new('Attachment'),Instance.new('Attachment')
			At0.Position = Character:FindFirstChild('Torso').Position
			At0.Parent = Character:FindFirstChild('Torso')
			
			At1.Parent = limbs
			At1.Position = limbs.Position
			BallSocketConstraint.Attachment1 = At1
		
			
			BallSocketConstraint.Enabled = true
			BallSocketConstraint.Attachment0 = At0
			BallSocketConstraint.Parent = limbs
			
			table.insert(TableofDeletionValues,{BallSocketConstraint,At0,At1})
			
		end
		
		
	end
	
	
	
	
end





return RagdollModule