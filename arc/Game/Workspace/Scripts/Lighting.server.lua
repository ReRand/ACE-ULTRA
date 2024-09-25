local lighting = game:GetService("Lighting");
local ingame = lighting.Ingame;


for _, s in ipairs(ingame:GetChildren()) do
    if lighting:GetAttribute(s.Name) then
        lighting[s.Name] = s.Value;
    else
        for _, c in ipairs(lighting:GetChildren()) do
            if c:GetAttribute(s.Name) then
                c[s.Name] = s.Value;
            end
        end
    end
end