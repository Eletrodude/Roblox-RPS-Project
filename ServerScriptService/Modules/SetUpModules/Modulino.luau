local Get = shared.Get

local SecMod = {}

function SecMod.Init()
	print('Started')
	
	local Mod = Get('TestModule')
	Mod.TestWorld('Start')
end


return SecMod