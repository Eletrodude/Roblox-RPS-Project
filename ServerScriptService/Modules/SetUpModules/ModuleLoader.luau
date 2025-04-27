--!strict
local ModuleLoader = {}
local Services = {}

function ModuleLoader.Get(ModuleName:string)
	return Services[ModuleName]
end

function ModuleLoader.Init(Scripts:{ModuleScript})
	for _,ModuleScript in Scripts do
		if not ModuleScript:IsA('ModuleScript') then continue end 
		
		
		local Module = require(ModuleScript) ::ModuleScript
		Services[ModuleScript.Name] = Module
	end
end

function ModuleLoader.Start()
	for _,ModuleScripts in Services do 
		if typeof(ModuleScripts) == 'function' then continue end
		
		if ModuleScripts.Init then 
			task.spawn(function()
				local Success,Error = pcall(ModuleScripts.Init)
				if not Success then 
					warn('Failed to initilize: ',ModuleScripts)
				end
			end)
		end
	end
end






shared.Get = ModuleLoader.Get

return ModuleLoader