--!strict
local RarityChooser = {}

--RarityChooser.__index = RarityChooser






--function RarityChooser.new()
--	local self = setmetatable({},RarityChooser)
	
--	local RaritiesTable = {"Common",'Rare','Legendary','Mythical'}
--	local RaritiesValues = {Common = 50,Rare = 30,Legendary = 19,Mythical = 1}
--	local RarityAbilities = {
--		Common = {'Fire','Water','Earth','Air'},
--		Rare = {'SuperStrength','Ice','Poison'},
--		Legendary = {'Lightning','Shadow'},
--		Mythical = {'Time'}
--	}
	
--	self.RaritiesTable = RaritiesTable
--	self.RaritiesValues = RaritiesValues
--	self.RarityAbilities = RarityAbilities
	
--	return self
	
--end


--function RarityChooser:GetRandomAbilities()
	
--	local RTable = self.RaritiesTable
--	local RValues = self.RaritiesValues
--	local RAbilities = self.RarityAbilities
	
--	local Number = math.random(1,100)
--	local Counter = 0
	
	

	
--	for index,value in RValues do 
--		Counter+=value
		
--		if Number <= Counter then
			
--			if index == 'Common' then
--				local Counter = 0 
--				local RanNum = math.random(1,#RAbilities.Common)
				
--				for index,value in pairs(RAbilities.Common) do 
					
					
--					if index == RanNum then
--						Counter = RAbilities.Common[RanNum]
--						return "Common",Counter
--					end
					
--				end
				
--			elseif index == 'Rare' then
--				local RanNum = math.random(1,#RAbilities.Rare)
				
--				for index,value in pairs(RAbilities.Rare) do 
					

--					if index == RanNum then
--						Counter = RAbilities.Rare[RanNum]
--						return "Rare",Counter
--					end

--				end
				
--			elseif index == 'Legendary' then
--				local RanNum = math.random(1,#RAbilities.Legendary)
--				for index,value in pairs(RAbilities.Legendary) do 
					

--					if index == RanNum then
--						Counter = RAbilities.Legendary[RanNum]
--						return "Legendary",Counter
--					end

--				end
				
--			elseif index == 'Mythical' then
--				local RanNum = math.random(1,#RAbilities.Mythical)

--				for index,value in pairs(RAbilities.Mythical) do 

--					if index == RanNum then
--						Counter = RAbilities.Mythical[RanNum]
--						return "Mythical",Counter
--					end

--				end
				
			
--			end
			
			
			
			
--		end
		
		
		
--	end
	
	
	
--end






return RarityChooser