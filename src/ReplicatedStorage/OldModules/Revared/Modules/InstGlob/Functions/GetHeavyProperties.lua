return (function(InstGlob)

	function InstGlob:GetProperties(class: string)
		local properties = {}
		
		if not InstGlob.Loaded then
			local http = game:GetService("HttpService")
			
			InstGlob.Version = http:GetAsync("http://setup.rprxy.xyz/versionQTStudio");
			local rawData = http:GetAsync("http://setup.rprxy.xyz/"..InstGlob.Version.."-API-Dump.json");
			InstGlob.Data = http:JSONDecode(rawData);
			InstGlob.Classes = InstGlob.Data.Classes
			
			InstGlob.Loaded = true;
		end

		for _, v in pairs(InstGlob.Classes) do
			if v.Name == class then
				for _, v2 in pairs(v.Members) do
					if v2.MemberType == "Property" then
						table.insert(properties.Properties, v2.Name)
					end
				end
			end
		end
		
		return properties;
	end

end)