local id = 0

function AddUID(child)
	if not child:GetAttribute("UUID") then
		child:SetAttribute("UUID", tostring(id))
		id += 1;
	end
end

for _, inst in game:GetDescendants() do
	AddUID(inst);
end

game.DescendantAdded:Connect(AddUID)