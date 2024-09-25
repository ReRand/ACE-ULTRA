local RevaEnum = {};
RevaEnum.__index = RevaEnum;


local RevaEnumItem = {};
RevaEnumItem.__index = RevaEnumItem;


-- enum item
function RevaEnumItem.new(name: string, value: number, et: RevaEnum)
	local self = setmetatable({
		
		Name = name,
		Value = value,
		EnumType = et
		
	}, RevaEnumItem);

	return self;
end


-- enum main
function RevaEnum.new(name, items)
	local self = setmetatable({
		Name = name,
		Items = items,
		-- Me = nil
	}, RevaEnum);


	-- self.Me = Enum[name];

	for itemValue, itemName in ipairs(self.Items) do
		self.Items[itemName] = RevaEnumItem.new(itemName, itemValue, self);
	end

	return self;
end


function RevaEnum:GetEnumItems()
	return self.Items;
end


return RevaEnum;