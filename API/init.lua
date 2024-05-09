local API = {

  Classes = {}
  
};
API.__index = API;



if not _G.API then
  _G.API = API;
  return API;
  
else
  return _G.API;

end
