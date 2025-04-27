--!strict
local RagdollModule = {}
RagdollModule.__index = RagdollModule

local attachmentCFrames = {
	["Head"] = {CFrame.new(0, -0.5, 0), CFrame.new(0, 1, 0)},
	["Left Arm"] = {CFrame.new(0, 0.5, 0), CFrame.new(-1, 0.5, 0)},
	["Right Arm"] = {CFrame.new(0, 0.5, 0), CFrame.new(1, 0.5, 0)},
	["Left Leg"] = {CFrame.new(0, 1, 0), CFrame.new(-0.5, -1, 0)},
	["Right Leg"] = {CFrame.new(0, 1, 0), CFrame.new(0.5, -1, 0)}
}

-- Forward declaration of helper functions
local function DisableMotor6D(Character)
	local Torso = Character:FindFirstChild("Torso")

	Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)

	for _, motor in pairs(Character:GetDescendants()) do
		if motor:IsA("Motor6D") then
			local socket = Instance.new("BallSocketConstraint")
			local a0 = Instance.new("Attachment")
			local a1 = Instance.new("Attachment")

			if motor.Part0 and motor.Part1 then
				a0.CFrame = motor.C0
				a1.CFrame = motor.C1
				a0.Parent = motor.Part0
				a1.Parent = motor.Part1
				socket.Attachment0 = a0
				socket.Attachment1 = a1
				socket.Parent = motor.Part1.Parent

				motor.Part1.Velocity = Vector3.new(0, 0, 0)
				motor.Part1.RotVelocity = Vector3.new(0, 0, 0)

				motor.Enabled = false
				motor.Part0 = nil
				motor.Part1 = nil
			end
		end
	end
end

local function CreateSockets(Part0, Part1)
	if not Part0 or not Part1 then
		warn("CreateSockets received nil parts:", Part0, Part1)
		return
	end

	local attachmentInfo = nil
	if Part1.Name == "Head" or Part1.Name == "Left Arm" or Part1.Name == "Right Arm" or Part1.Name == "Left Leg" or Part1.Name == "Right Leg" then
		attachmentInfo = attachmentCFrames[Part1.Name]
	end

	if not attachmentInfo then
		warn("No attachment configuration for part:", Part1.Name)
		return
	end

	local Attachment0 = Instance.new('Attachment')
	local Attachment1 = Instance.new('Attachment')

	Attachment0.CFrame = attachmentInfo[1]
	Attachment0.Parent = Part0

	Attachment1.CFrame = attachmentInfo[2]
	Attachment1.Parent = Part1

	local BallSocketConstraints = Instance.new('BallSocketConstraint')
	BallSocketConstraints.Attachment0 = Attachment0
	BallSocketConstraints.Attachment1 = Attachment1
	BallSocketConstraints.LimitsEnabled = true
	BallSocketConstraints.TwistLimitsEnabled = true
	BallSocketConstraints.UpperAngle = 90
	BallSocketConstraints.TwistLowerAngle = -90
	BallSocketConstraints.TwistUpperAngle = 90
	BallSocketConstraints.Parent = Part0

	return BallSocketConstraints
end

local function EnablePhysics(Character)
	for _, Part in pairs(Character:GetChildren()) do 
		if Part:IsA('BasePart') then 
			Part.Massless = false
			Part.CanCollide = true
			Part.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
		end
	end
end

local function storeMotors(Character, Motor)
	for _, motor in pairs(Character:GetDescendants()) do
		if motor:IsA("Motor6D") then
			Motor[motor] = {C0 = motor.C0, C1 = motor.C1, Part0 = motor.Part0, Part1 = motor.Part1}
		end
	end
end

local function DisableRagdoll(Character, Motor)
	Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	Character.Humanoid.PlatformStand = false
	Character.Humanoid.AutoRotate = true

	for motor, state in pairs(Motor) do
		if motor.Parent then
			motor.Part0 = state.Part0
			motor.Part1 = state.Part1
			motor.C0 = state.C0
			motor.C1 = state.C1
			motor.Enabled = true
		end
	end

	for _, part in pairs(Character:GetDescendants()) do
		if part:IsA("BallSocketConstraint") or part:IsA("Attachment") then
			part:Destroy()
		end
	end
end

function RagdollModule.new(Character) 
	local Parts = {}
	local OriginState = {}
	local WeldedParts = {}
	local Motors = {}

	if not Character then 
		warn('Character not found')
		return nil
	end

	local Humanoid = Character:FindFirstChildWhichIsA('Humanoid')

	if not Humanoid then 
		warn('Humanoid not found')
		return nil
	end

	local self = setmetatable({}, RagdollModule)

	for _, CharacterParts in pairs(Character:GetChildren()) do 
		if CharacterParts:IsA('BasePart') then
			OriginState[CharacterParts] = {
				CanCollide = CharacterParts.CanCollide,
				Anchored = CharacterParts.Anchored,
				Massless = CharacterParts.Massless
			}
			table.insert(Parts, CharacterParts)
		end
	end

	if #Parts ~= 7 then 
		warn('Incorrect number of BaseParts found in character')
		return nil
	end

	storeMotors(Character, Motors)

	self.Character = Character
	self.OriginState = OriginState
	self.Parts = Parts
	self.WeldedParts = WeldedParts
	self.Motors = Motors

	return self
end

function RagdollModule:RagdollCharacter()
	local Character = self.Character
	local Parts = self.Parts

	local Humanoid = Character:FindFirstChildWhichIsA('Humanoid')

	if not Humanoid then 
		warn('Humanoid not found')
		return
	end

	Character:SetAttribute('IsRagdolled', true)

	Humanoid.PlatformStand = true
	Humanoid.AutoRotate = false

	DisableMotor6D(Character)
	EnablePhysics(Character)

	local Torso = Character:FindFirstChild('Torso')
	if not Torso then
		warn('Torso not found')
		return
	end

	for _, part in pairs(Character:GetChildren()) do 
		if part:IsA('BasePart') and part.Name ~= 'Torso' and part.Name ~= 'HumanoidRootPart' then 
			CreateSockets(Torso, part)
		end
	end
end

function RagdollModule:DisableRagdoll()
	DisableRagdoll(self.Character, self.Motors)
	self.Character:SetAttribute('IsRagdolled', false)
end

function RagdollModule:Destroy()
	self.Character = nil
	self.OriginState = nil
	self.Parts = nil
	self.WeldedParts = nil
	self.Motors = nil
	setmetatable(self, nil)
end

return RagdollModule