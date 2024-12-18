--!strict


local AceWeapon = require(script.Parent.AceWeapon);
local Signal = require(script.Parent.Parent.Signal);


export type AcePlayer = {
	Player: Player,

	Weapons: { [number]: AceWeapon.AceWeapon },

	Killed: Signal.Signal<AcePlayer, AcePlayer, AceWeapon.AceWeapon>,
	Suicided: Signal.Signal<AcePlayer>


}


return {};