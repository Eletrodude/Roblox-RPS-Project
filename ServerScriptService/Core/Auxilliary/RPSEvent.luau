--!strict
--[[ 
    Title: [RPS Picker]
    Description: [Enables players to pick between Rock, Paper or Scissors, when the round starts]
    Author: [Eletrodude]
    Date: [13/03/2025]
--]]

-- SERVICES
-- (Game services like Players, DataStoreService, ReplicatedStorage, etc.)
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local PlayerService = game:GetService('Players')

-- VARIABLES
-- (Local variables that store data or references)
local Choices = {}
local AbilitiesChosen = {}
--local Round = workspace:GetAttribute('Round')	


-- CONSTANTS
-- (Values that do not change throughout the script)
local BindableEvent = ReplicatedStorage.BindableEvents
local RemoteEvents = ReplicatedStorage.Remotes
local AuxilliaryEvents = RemoteEvents.Auxilliary

local RPSChooser = AuxilliaryEvents.RPSChooser
local RPSEvent = BindableEvent.RPSEvent

-- MODULES
-- (Require any external modules or scripts)
local Maid = require(game:GetService('ServerScriptService').Modules.CoreModules.Maid)
local WinnersModule = require(game:GetService('ServerScriptService'):WaitForChild('Modules').CoreModules.WinnerTable)

-- FUNCTIONS
-- (Define reusable functions here)

--Fires the rock paper scissors event, takes round as variable
local function FireRPSEvents(Round,str)
	
	if Round == 1 then 
	RPSChooser:FireAllClients('First Round')
		workspace:SetAttribute('Round',Round)
	elseif Round == 2 then
		RPSChooser:FireAllClients('Second Round')
		workspace:SetAttribute('Round',Round)
	elseif Round == 3 then
		workspace:SetAttribute('Round',Round)
		RPSChooser:FireAllClients('Third Round')
	elseif Round == 'Remove' then
		RPSChooser:FireAllClients('Remove')

	end
	
	
end

local function SelectWinner(Table1,Table2)
	local Round = workspace:GetAttribute('Round')	
	
	local FirstPlayer = Table1[1]
	local SecondPlayer = Table2[1]

	--This works correctly
	
	
	local FirstPlayerChoice = Table1[2].Choice
	local SecondPlayerChoice = Table2[2].Choice
	--This also works correctly, Table1[2][1], for example, COULD be Rock,Paper or Scissors, same as the other table
	
	
	if (FirstPlayerChoice == 'Rock' and  SecondPlayerChoice == 'Rock') or 
		(FirstPlayerChoice == 'Paper' and SecondPlayerChoice == 'Paper') or 
		(FirstPlayerChoice == 'Scissors' and SecondPlayerChoice == 'Scissors') then 
		--warn('Tie')
		
		return 'Tie'
	elseif (FirstPlayerChoice == 'Rock' and SecondPlayerChoice == 'Scissors') or 
		(FirstPlayerChoice == 'Scissors' and SecondPlayerChoice == 'Paper') or
		(FirstPlayerChoice == 'Paper' and SecondPlayerChoice == 'Rock') then
		--warn(FirstPlayer.Name.. ' has won with choice: '..FirstPlayerChoice)
		
		local Winner = WinnersModule.new(FirstPlayer,Round)
		Winner:AddWinner()
		
		
		
	return FirstPlayer,FirstPlayerChoice
	
	elseif (SecondPlayerChoice == 'Rock' and FirstPlayerChoice == 'Scissors') or 
		(SecondPlayerChoice == 'Scissors' and FirstPlayerChoice == 'Paper') or
		(SecondPlayerChoice == 'Paper' and FirstPlayerChoice == 'Rock') then
		--warn(SecondPlayer.Name.. ' has won with choice: '..SecondPlayerChoice)
		local Winner = WinnersModule.new(SecondPlayer,Round)
		Winner:AddWinner()

		return SecondPlayer,SecondPlayerChoice
	
	end
	
	
	
end

-- MAIN SCRIPT LOGIC
-- (Core script execution and function calls)

-- HANDLERS
-- (Event listeners and connections)
RPSEvent.Event:Connect(function(Player1,Player2)
	local Round = workspace:GetAttribute('Round')	
	if Player1 and Player2 then
		FireRPSEvents(Round)
		print(Player1,Player2)
		
	end
	
end)

RPSChooser.OnServerEvent:Connect(function(Player,Choice:string)
	local Round = workspace:GetAttribute('Round')	
	local PlayerChoices = {}
	
	if not Choices[Player] then
		Choices[Player] = {
			Player = Player,
			Choice = Choice
		}
	end
	
	for index,value in pairs(Choices) do 
		if not table.find(PlayerChoices,{index,value}) then
			table.insert(PlayerChoices,{index,value})
		end
	end
	
	
	
	if #PlayerChoices == 2 then
		local Winner,WinningChoice = SelectWinner(PlayerChoices[1],PlayerChoices[2])
		
		if Winner == 'Tie' then
			Choices = {}
			
			FireRPSEvents('Remove')
			task.wait(0.3)
			FireRPSEvents(Round)
			return
		end
		
		
		if Winner and WinningChoice then
			FireRPSEvents('Remove')
			task.wait(0.5)
			RPSChooser:FireAllClients('PlayAnimation',PlayerChoices[1],PlayerChoices[2],Winner)
			warn(PlayerChoices[1],PlayerChoices[2],Winner,Round)
			Choices = {}
		end
		
		
		
	elseif PlayerChoices[1][1]  and #PlayerChoices == 1 then
		RPSChooser:FireClient(PlayerChoices[1][1],'Wait')
	elseif PlayerChoices[2][1] and #PlayerChoices == 1 then
		RPSChooser:FireClient(PlayerChoices[2][1],'Wait')
	end
end)

-- ERROR HANDLING
-- (pcall or other error-handling mechanisms)




