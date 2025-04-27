--!strict
--!nocheck
--[[

Title: [Pick Abilities]
Description: [Fires a remote so players can Pick a selection of Abilities]
Author: [Eletrodude]
Date: [10/03/2025]
--]]
-- SERVICES
-- (Game services like Players, DataStoreService, ReplicatedStorage, etc.)
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServerScriptService = game:GetService('ServerScriptService')

-- MODULES
-- (Require any external modules or scripts)
local WinnerTable = require(ServerScriptService:WaitForChild('Modules').CoreModules.WinnerTable)
local RarityChooser = require(ServerScriptService.Modules.RarityChooser2)
local PlayerTable = require(ServerScriptService.Modules.CoreModules.PlayerTable)
--local Rarities = RarityChooser.new()

-- VARIABLES
-- (Local variables that store data or references)
local PlayerAbilitiesChosen = {Round1 = {},Round2 = {},PlayerTotal  = {}}
local RandomAbilitiesChosen = {Round1 = {},Round2 = {}}
local AbilityChosenTable = {Round1 = {},Round2 = {}}




local TurnState = {
	CurrentPicker = nil,
	CurrentRound = 1,
	CurrentTurn = 1,
	AvailableCards = {}
}





local ClonedTable 




-- CONSTANTS
-- (Values that do not change throughout the script)
local PickAbilityEvent = ReplicatedStorage.BindableEvents.PickAbility
local ClientPickAbility = ReplicatedStorage.Remotes.Auxilliary.PickAbilities
-- FUNCTIONS

--Generates the random abilities to be used during the round
local function GenerateAbilities()
	--[[for index = 1,8 do 
		local Rarity,Ability = Rarities:GetRandomAbilities()

		local AbilityInformation = {Rarity,Ability}

		if index <= 4 then
			table.insert(RandomAbilitiesChosen.Round1,AbilityInformation)
			table.insert(AbilityChosenTable.Round1,AbilityInformation)
		elseif index > 4 then
			table.insert(RandomAbilitiesChosen.Round2,AbilityInformation) 
			table.insert(AbilityChosenTable.Round2,AbilityInformation)

		end
		if index == 8 then
			ClonedTable = table.clone(RandomAbilitiesChosen)
		end
	end]]
	
	local Abilities1,Abilites2 = RarityChooser:ChooseAbilities()
	RandomAbilitiesChosen.Round1 = Abilities1
	AbilityChosenTable.Round1 = Abilities1
	
	RandomAbilitiesChosen.Round2 = Abilites2
	AbilityChosenTable.Round2 = Abilites2
	
	ClonedTable = table.clone(RandomAbilitiesChosen)
	
	
end

--Allowes players to start picking abilities
local function StartPickingAbility()
	local Round = workspace:GetAttribute('Round')
	local Winner:Player = WinnerTable.LookForWinner(Round::number)[1]::Player
	
	if not Winner:IsA('Player') then
		Winner = game:GetService('Players'):FindFirstChild(Winner)
	end
	
	
	local Player1,Player2 = PlayerTable:LookForPlayers()
	TurnState.AvailableCards = RandomAbilitiesChosen['Round'..Round]
	TurnState.CurrentPicker = Winner
	TurnState.CurrentTurn = 1
	TurnState.CurrentRound = Round
	
	PlayerAbilitiesChosen['Round'..Round] = {[Player1] = {},[Player2] = {}}
	
	ClientPickAbility:FireClient(Winner,TurnState.AvailableCards,'Initiate')
	local otherPlayer = (Winner == Player1) and Player2 or Player1
	ClientPickAbility:FireClient(otherPlayer, TurnState.AvailableCards, 'WaitingForTurn')

	return Winner
end


local function ProcessAbilties()
	local Player1:Player,Player2:Player = PlayerTable:LookForPlayers()
	

	local AbilitiesTable = ClonedTable['Round'..workspace:GetAttribute('Round')]
	warn(AbilitiesTable)
	warn()
	
	local PlayerAbilities = PlayerAbilitiesChosen['Round'..workspace:GetAttribute('Round')]
	
	
	
	
	Player1.Character:SetAttribute('CurrentAbility',PlayerAbilities[Player1][1])
	Player1.Character:SetAttribute('CurrentAbility2',PlayerAbilities[Player1][2])
	
	Player2.Character:SetAttribute('CurrentAbility',PlayerAbilities[Player2][1])
	Player2.Character:SetAttribute('CurrentAbility2',PlayerAbilities[Player2][2])
	
	warn(Player1.Character:GetAttributes(),Player2.Character:GetAttributes())
	


	
	ClientPickAbility:FireAllClients(nil,'Close')
	
end




--Dynamically Handle Ability Selection for players.
local function HandleAbilitySelection(player,CardChosen)
	local Player1,Player2 = PlayerTable:LookForPlayers()
	local Round = workspace:GetAttribute('Round')
	
	--So the wrong player doesn't get fired.
	if player ~= TurnState.CurrentPicker then
		return 
	end
	
	--Chooses ability card.
	local CardChosen = tonumber(CardChosen)
	local SelectedAbility = TurnState.AvailableCards[CardChosen]
	warn('Round'..workspace:GetAttribute('Round'))
	--table.insert(PlayerAbilitiesChosen['Round'..workspace:GetAttribute('Round')],SelectedAbility)
	
	local PlayerTable = PlayerAbilitiesChosen['Round'..Round]
	local AbilityChosen = RandomAbilitiesChosen['Round'..Round][CardChosen]
	
	
	table.insert(PlayerTable[TurnState.CurrentPicker],AbilityChosen[2])
	
	if not PlayerAbilitiesChosen.PlayerTotal[player] then
		PlayerAbilitiesChosen.PlayerTotal[player] = {}
		
	end
	
	table.insert(PlayerAbilitiesChosen.PlayerTotal[player],AbilityChosen[2])
	warn(Round,PlayerAbilitiesChosen.PlayerTotal)

	print(PlayerTable)
	
	
	
	
	--Removes choice so players cannot pick the same card.
	table.remove(TurnState.AvailableCards,CardChosen)
	
	ClientPickAbility:FireAllClients('Remove',CardChosen)
	
	TurnState.CurrentTurn += 1
	
	--If turns are over(4 max) then give all players their abilities.
	if TurnState.CurrentTurn == 5 then
		ProcessAbilties()
		--ClientPickAbility:FireClient(TurnState.CurrentPicker,nil,'Close')
		TurnState.CurrentTurn = 0
		TurnState.CurrentPicker = nil
		return
	end
	
	--Switches Player turns
	if TurnState.CurrentPicker == Player1 then
		TurnState.CurrentPicker = Player2
	else 
		TurnState.CurrentPicker = Player1
	end
	
	--local find = table.find(ClonedTable['Round'..workspace:GetAttribute('Round')][TurnState.CurrentPicker],CardChosen)
	--print(find)
	--table.insert(PlayerAbilitiesChosen['Round'..workspace:GetAttribute('Round')][TurnState.CurrentPicker],find)
	print(PlayerAbilitiesChosen)
	
	ClientPickAbility:FireClient(TurnState.CurrentPicker,TurnState.AvailableCards,'Turn')
	
	
	local otherPlayer = (TurnState.CurrentPicker == Player1) and Player2 or Player1
	ClientPickAbility:FireClient(otherPlayer,nil,'WaitingForTurn')
end





-- (Define reusable functions here)
-- MAIN SCRIPT LOGIC
-- (Core script execution and function calls)




task.delay(10,GenerateAbilities)
-- HANDLERS
-- (Event listeners and connections)

PickAbilityEvent.Event:Connect(function()
	--local Player = pcall(StartPickingAbility)
	local success,Winner = pcall(StartPickingAbility)
	
	if success == false then
		task.delay(1,StartPickingAbility)
	end

	
	--print(RandomAbilitiesChosen.Round1)
	--local Table = RandomAbilitiesChosen['Round'..workspace:GetAttribute('Round')]
	
	--local Player1,Player2 = PlayerTable:LookForPlayers()
	
	--ClientPickAbility:FireClient(Winner,Table,'Initiate')
	
	
	
	
end)


--local Initiate = false

local Connection = ClientPickAbility.OnServerEvent:Connect(function(Player,Choice)
	
	
	
	HandleAbilitySelection(Player,Choice)
	
	
	
	--[[
	
	-- local PlayerChoices = {}
	--print(Choices)
	
	--if not Choices[Player] then
	--	Choices[Player] = {Player,Ability1 = Choice,Ability2 = nil,Counter = 0}
	--end
	
	--local Player1,Player2 = PlayerTable:LookForPlayers()
	
	--print(Choices)
	
	--local Winner = WinnerTable.LookForWinner(workspace:GetAttribute('Round'))
	
	
	
	--ClientPickAbility:FireAllClients('Remove',Choice)
	
	
	--print(Player1,Player2)
	
	
	--if Winner == Player1 and Initiate == false  then
	--	warn('w')
	--	Initiate  = true
	--	ClientPickAbility:FireClient(Player2,RandomAbilitiesChosen['Round'..workspace:GetAttribute('Round')],'Initiate')
	--	ClientPickAbility:FireClient(Player2)
	--	Player2.PlayerGui.ChooseAbility = true
		
	--elseif Winner == Player2 and Initiate == false then
	--	warn('W')
	--	Initiate = true
	--	ClientPickAbility:FireClient(Player1,RandomAbilitiesChosen['Round'..workspace:GetAttribute('Round')],'Initiate')
	--	Player1.PlayerGui.ChooseAbility = true

	--end
		
	
	
	--Choices[Player].Counter +=1
	
	--if Choices[Player].Counter == 2 then
	--	Choices[Player].Ability2 = Choice
	--end
	
	
	--print(Player1,Player2)
	--if Choices[Player1].Counter == 2 and Choices[Player2].Counter == 2 then
	--	print('Both players have chosen 2 abilities')
	--end
	
	
	
	--for index,value in pairs(Choices) do 
	--	table.insert(PlayerChoices,{index,value})
	--end
	
	----if PlayerChoices[1] and PlayerChoices[2] then
	----	print('Both players have chosen...')
	----end
	]]
	
	
end)




-- ERROR HANDLING
-- (pcall or other error-handling mechanisms)
