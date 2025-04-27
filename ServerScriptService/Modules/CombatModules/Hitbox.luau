--!strict

export type HitboxModuleScript = {
	Player: Player,
	SpacialQuery: (Size: Vector3, cFrame: CFrame, Debris: number, Mode: number, HitboxIgnoreList:{Instance}?, viewHitbox: boolean) -> {Model}?
}

local HitboxModule = {}


--[[
This Handler requires a few items to work correctly:
Type of Hitbox: Raycast, Spacial query, BlockCast, just type in the number for the hitbox
Size of Hitbox:Vector3 OR number
Debris: Duration of hitbox
Mode:One-time check, Continous check, Destroy on hit( still requires a debris)
]]
local HitboxVisualiser = function(cframe,Size)
	local DebugPart = Instance.new('Part')
	DebugPart.Transparency = 0.2
	DebugPart.Material = Enum.Material.ForceField
	DebugPart.Color = Color3.new(1, 0, 0)
	DebugPart.Anchored = true
	DebugPart.CFrame = cframe
	DebugPart.Size = Size
	DebugPart.Parent = workspace.HitboxIgnore
	DebugPart.CanCollide = false
	game.Debris:AddItem(DebugPart,0.3)
	
end





--Requires following elements: Size,CFrame,Debris,Number,Mode,HitboxIgnoreList,Visualizer
function HitboxModule:SpacialQuery(Player:Player,Size:Vector3,cFrame:CFrame,Debris:number,Mode:number,HitboxIgnoreList:{Instance}?,viewHitbox:boolean)

	
	local Character:Model? = Player.Character
	
	local TableOfThingsHit:{Model} = {}
	local HitDictionary = {}
	local IgnoreList = {}
	
	if not Character then 
		warn('Character not found')
		return {}
	end
	
	if not Size then 
		Size = Vector3.new(8,8,8)
	end
	
	if not cFrame then 
		local HumanoidRootPart = Character:FindFirstChild('HumanoidRootPart')::BasePart
		cFrame = HumanoidRootPart.CFrame * CFrame.new(0,0,-3)
	end
	
	if not Debris then 
		Debris = 0.3
	end
	
	if not Mode then 
		Mode = 1
	end
	
	if not HitboxIgnoreList then 
		IgnoreList = {Character,workspace:FindFirstChild('Map'),workspace:FindFirstChild('HitboxIgnore')}
		HitboxIgnoreList = IgnoreList::{Instance}
		
		
	end
	
	local IgnoredCopy = {}
	
	for _,v in ipairs(IgnoreList) do
		table.insert(IgnoredCopy,v)
	end
	
	
	
	local OverlapParameters = OverlapParams.new()
	
	OverlapParameters.FilterType = Enum.RaycastFilterType.Exclude
	OverlapParameters.FilterDescendantsInstances = HitboxIgnoreList::{Instance}
	
	local Hitbox = workspace:GetPartBoundsInBox(cFrame,Size,OverlapParameters)
	
	
	if viewHitbox == true then
		HitboxVisualiser(cFrame,Size)
	end
	
	if #Hitbox > 0 then
		for index,value in pairs(Hitbox) do 
			
			local HitCharacter = value:FindFirstAncestorOfClass('Model')::Model
			
			if HitCharacter and not HitDictionary[HitCharacter] and HitCharacter:FindFirstChildWhichIsA('Humanoid') then 
				HitDictionary[HitCharacter] = true
				table.insert(TableOfThingsHit,HitCharacter)
				
				--print(HitCharacter)
				
		
			end
			
		end
		return  TableOfThingsHit
	end
	
	

	
	
	
	return {}
	
end




return HitboxModule