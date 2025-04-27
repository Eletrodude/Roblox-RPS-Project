--!strict
local WinnerTable = {}

local TableofWinners = {}

WinnerTable.__index = WinnerTable

function WinnerTable.new(Winner:Player,Round:number)
	local self = setmetatable({},WinnerTable)
	
	if not Winner or not Winner:IsA('Player') then
		error('Winner not Found or nil:'.. Winner)
	end
	
	if not Round or type(Round) ~= 'number' then 
		error('Number is invalid or nil:'..Round)
	end
	
	self.Winner = Winner
	self.Round = Round
	
	
	
	return self
end



function WinnerTable:AddWinner()
	table.insert(TableofWinners,{self.Winner,self.Round})
	return self
end

function WinnerTable:LookFor(Round)
	for index,value in pairs(TableofWinners) do 
		if value.Round == Round then
			return value
		end
	end
end


function WinnerTable.LookForWinner(Round)
	return TableofWinners[Round]
end

return WinnerTable