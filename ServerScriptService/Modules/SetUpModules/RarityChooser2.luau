--!strict
local Rarities = {}

Rarities.RarityAbilities = {
	Common = {'Fire','Water','Earth','Air'},
	Rare = {'SuperStrength','Ice','Poison'},
	Legendary = {'Lightning','Shadow'},
	Mythical = {'Time'}
}

Rarities.RarityValues = {
	Common = 50, Rare = 30, Legendary = 19, Mythical = 1
}

Rarities.RarityTable = {'Common','Rare','Legendary','Mythical'}

function Rarities:ChooseAbilities()
	local Abilities1,Abilities2 = {},{}
	
	
	for Num = 1,8,1 do 
		
		
			local RandomizedAbilityNumber = math.random(1,100)
			local Weight = 0
			local ChosenAbility = nil
			
			
			
			for index,value in pairs(Rarities.RarityValues) do 
				Weight = Weight+value
				if RandomizedAbilityNumber <=Weight then 
					ChosenAbility = index
					break
				end
			end
			
			
			if ChosenAbility then 
				
			local RarityAbilities = Rarities.RarityAbilities[ChosenAbility]
			local RandomizedAbilityNumber = math.random(1, #RarityAbilities)
			local AbilityChosen = RarityAbilities[RandomizedAbilityNumber]

			if Num <= 4 then
				table.insert(Abilities1, {ChosenAbility, AbilityChosen})
			else
				table.insert(Abilities2, {ChosenAbility, AbilityChosen})
			end
		
			

			--[[for Rarity,Chance in Rarities.RarityValues do 
			--	Weight = Weight + Chance

			--	if RandomizedAbilityNumber <= Weight then 

			--		if Rarity then 
			--			local AbilityChosen = math.random(1,#Rarities.RarityAbilities[Rarity])

			--			for AbilityNumber,AbilityName in pairs(Rarities.RarityAbilities[Rarity]) do 
			--				if AbilityNumber == AbilityChosen then

			--					if Num <=4 then
			--						table.insert(Abilities1,{Rarity,AbilityName})
			--					elseif Num >=5 then
			--						table.insert(Abilities2,{Rarity,AbilityName})

			--					end
			--					--return index,AbilityName
			--				end

			--			end

			--		end
			--	end
]]
			end



	
	end	
	print(Abilities1,Abilities2)
	return Abilities1,Abilities2
end


return Rarities