--!strict
local ServerScriptService = game:GetService('ServerScriptService')
local ModuleTable = {}

local ModuleLoader = require(ServerScriptService.Modules.ModuleLoader)


for _,Modules in pairs(ServerScriptService.Modules:GetDescendants()) do 
	if not Modules:IsA('ModuleScript') then 
		continue
	end 
	
	if Modules.Name == 'ModuleLoader' or Modules.Name == 'MyServices' then 
		continue 
	end
	
	table.insert(ModuleTable,Modules)
	
end

ModuleLoader.Init(ModuleTable)
ModuleLoader.Start()


