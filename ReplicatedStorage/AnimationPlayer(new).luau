local AnimationPlayer = {}
	 --	{ AnimationID = "",MarkerReachedName = {},Cancellable = false,
--	StopAt = 0
--}
AnimationPlayer.__index = AnimationPlayer


function AnimationPlayer.new(Player,AnimationID,MarkerReachedSignals,Cancellable,StopAt,event:RemoteEvent,Dummy:Model)
	
	if not Player  and not Dummy then 
		error("No player or Invalid Player")
	end
	
	if type(AnimationID) ~= "string"  or AnimationID == nil then 
		print(AnimationID)
		error("AnimationID invalid or Missing")
		return
	end
	
	if not event or not event:IsA("RemoteEvent") then
		print(event)
		error("Invalid Event")
	end
	
	local self = setmetatable({},AnimationPlayer)
	
	if type(MarkerReachedSignals) ~= "table" then
		warn("Not a table or Missing")
		MarkerReachedSignals = {}
	end
	
	if not Player and Dummy then
		self.Dummy = Dummy
	else 
		self.Player = Player
	end
	
	
	self.AnimationID = AnimationID
	self.MarkerReachedName = MarkerReachedSignals
	self.Cancellable = Cancellable
	self.StopAt = StopAt
	self.Event = event
	
	--AnimationPlayer:PlayAnimation(Player,AnimationID,MarkerReachedSignals,Cancellable,StopAt,event)


	return self
	

end


function AnimationPlayer:PlayAnimation(StringToFire)
	local Character
	
	if  self.Player then
		local Player = self.Player
	
	
	 Character = Player.Character
	
	elseif self.Dummy and not self.Player then
		 Character = self.Dummy
	end
	
	if not Character then
		error("No Character")
	end
	
	if not Character.PrimaryPart and Character:FindFirstChild("HumanoidRootPart") then
		Character.PrimaryPart = Character.HumanoidRootPart
	end
	
	
	local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
	
	if not Humanoid then
		error("No Humanoid")
	end
	
	local Animator = Humanoid:FindFirstChildWhichIsA("Animator")
	
	if not Animator then
		error("Animator not found")
	end
	
	print("We reached here bois")
	
	
	local Animation = Instance.new("Animation")
	Animation.AnimationId = self.AnimationID
	
	local track = Animator:LoadAnimation(Animation)::AnimationTrack
	track:Play()
	print(track.IsPlaying)
	
	
	track.KeyframeReached:Connect(function(keyframeName)
		-- Fire the event with the keyframe name
		print("wow, Surprised it works")
		self.Event:FireServer(keyframeName)
	end)
	
	
	if #self.MarkerReachedName > 0 then
		for i,v in pairs(self.MarkerReachedName) do
		
			track:GetMarkerReachedSignal(v):Connect(function()
			
				self.Event:FireServer(v)
			end)
			
		end
	end
	
	
	track.Ended:Connect(function()
		self.Event:FireServer('Complete',StringToFire)
		print('FIRED')
	end)
	
	return self
end




return AnimationPlayer