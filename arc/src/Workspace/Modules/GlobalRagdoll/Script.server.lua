local ragdoll = game.ReplicatedStorage.GlobalRagdoll.Ragdoll
local unragdoll = game.ReplicatedStorage.GlobalRagdoll.UnRagdoll;

function doRagdoll(player,character)
	for _, v in pairs(character:GetDescendants()) do  --ragdoll
		if v:IsA("Motor6D") then
			local a0, a1 = Instance.new("Attachment"), Instance.new("Attachment")
			a0.CFrame = v.C0
			a1.CFrame = v.C1
			a0.Parent = v.Part0
			a1.Parent = v.Part1
			local b = Instance.new("BallSocketConstraint")
			b.Attachment0 = a0
			b.Attachment1 = a1
			b.Parent = v.Part0
			v.Enabled = false
		end
	end
end


function doUnRagdoll(player, character)
	for _,v in pairs(character:GetDescendants()) do  --unragdoll
		if v:IsA('Motor6D') then
			v.Enabled = true
		end
		if v.Name == 'BallSocketConstraint' then
			v:Destroy()
		end
		if v.Name == 'Attachment' then
			v:Destroy()
		end
	end
end



ragdoll.OnServerEvent:connect(doRagdoll)
unragdoll.OnServerEvent:connect(doUnRagdoll)