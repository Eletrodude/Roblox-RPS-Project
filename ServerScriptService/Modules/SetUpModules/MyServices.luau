
local ModuleFolder = script.Parent
local FolderOfModules = {}


local Services = {}

local RunService = game:GetService('RunService')



for FolderNum,Folder in pairs(ModuleFolder:GetChildren()) do 
	table.insert(FolderOfModules,Folder)
end

Services['Services'] = {}


local serviceFolders = {}


function Services:FetchAllServices()
	local Number = 0
	if #self['Services'] == 0 then 
		
		for i,Modules:ModuleScript in pairs(ModuleFolder:GetDescendants()) do 
			local Mod = Modules::ModuleScript
			Number+=1
			
			if Modules.Name == 'MyServices' or Modules.Name == 'SafeTeleport' or Modules.Name == 'WinnerTable' or Modules.Name == 'Ragdoll(Mid)' then
				continue
			end

		
			if Modules:IsA('ModuleScript') then 
				
				local ServiceName = Modules.Name
				local ServiceData = require(Modules)
				
				
				
				--if ServiceData['Init'] then 
				--	task.spawn(function()
				--		local InitResult = ServiceData:Init()
						
				--		if InitResult then 
				--			print('Module Loader: Successfully initiated '..ServiceName )
							
				--		else warn('Module Loader: Error on initiating '..ServiceName)
				--		end
						
						
				--	end)
				
				if typeof(ServiceData) == 'table' and typeof(ServiceData.new) == 'function' then 
					task.spawn(function()
						Services[ServiceName] = ServiceData.new()
					end)
				else 
					Services[ServiceName] = ServiceData
				
				
				
				end
				
				
				self['Services'][ServiceName] = ServiceData
			end
		end
	end
	return Services['Services']
	
end

function Services:GetService(ServiceTypedName)
	local TotalAttempts = 3
	local AttemptCooldown = 0.5

	local function attempt()
		
		for ServiceName,ServiceData in pairs(self['Services']) do 
			
			if ServiceName == ServiceTypedName then 
				return ServiceData
			end
			
		end
	end
	
	
	for i = 1,TotalAttempts do 
		task.wait(AttemptCooldown)
		local Result = attempt()
		
		if Result then 
			return Result
		end
	end
	
	
	warn('RESULT NOT ACQUIRED!',debug.traceback())
	
end




return Services