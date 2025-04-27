--!strict
local Players = {}
local PlayerTable = {}



function Players:AddPlayers(Player1:Player,Player2:Player)
	if not Player1 then
		warn(Player1,'missing')
		return
	end
	
	if not Player2 then
		warn(Player2,' missing') 
		return
	end
	
	--self.Player1= Player1
	--self.Player2 = Player2
	
	
	PlayerTable = {Player1,Player2}
	
	
	
end



function Players:LookForPlayers()
	

	
	
	return PlayerTable[1],PlayerTable[2]
end


return Players
