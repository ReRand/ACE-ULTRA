--!optimize 2
--!nonstrict
--!native

local LemonSignal = require(script.Parent.Parent.LemonSignal)

local Nodes = {
	Enums = {}
}

export type NodeList = {
	Enums: {},
	Init: (self: { [string]: any }, from: { [string]: any }) -> any,

	Node: _NodeStatic,
	EntityCollection: _EntityCollectionStatic,
	Entity: _EntityStatic,
	EntityInfo: _EntityInfoStatic,
	Weapon: _WeaponStatic,
	Perk: _PerkStatic,
	Projectile: _ProjectileStatic,
	ProjectileInfo: _ProjectileInfoStatic,
}


function Nodes.New( NodeName: string, ...)
	local self = {
		NodeName =  NodeName,
		Extensions = #{...} > 0 and {...} or {},
		Prototype = {}
	}

	return NodeName, self
end


function Nodes.Init(self: { [string]: any }, from: { [string]: any })
	self.NodeName = from.NodeName or "Node"
	self.Metadata = self.Metadata or {}
	self.Children = self.Children or {}
	self.Parent = self.Parent
	self.Index = self.Index or 1

	-- inherit from node type's prototype
	for k, v in from.Prototype do
		self[k] = self[k] or v
	end

	-- inherit from node's extensions
	for _, t in from.Extensions do
		for k, v in Nodes[t].Prototype do
			self[k] = self[k] or v
		end
	end

	return self
end



--[[ Ace Class ]]--
-- extends into almost every class
-- contains base information for classes
do local n, t = Nodes.New("Node") Nodes[n] = t :: _NodeStatic end
export type _NodeStatic = {
	NodeName: string,
	Extensions: { [number]: string },
	Prototype: _Node,
	
	New : () -> _Node,
}
export type _Node = {
	NodeName : string,
	Metadata: {},
	Children: {},
	Parent: _Node,
	Destroy : (self : any) -> nil,
}



--[[ Ace Entity Collection ]]--
-- collection of entities with functions relating to them
do local n, t = Nodes.New("EntityCollection", "Node") Nodes[n] = t :: _EntityCollectionStatic end
export type _EntityCollectionStatic = _NodeStatic & {
	New : (..._Entity) -> _EntityCollection,
}
export type _EntityCollection = _Node & { [string]: _Entity }



--[[ Ace Entity ]]--
-- entity class covering ai and players
do local n, t = Nodes.New("Entity", "Node") Nodes[n] = t :: _EntityStatic end
export type _EntityStatic = _NodeStatic & {
	New : (base: Player | Model, info : _EntityInfo) -> _Entity,
}
export type _Entity = _Node & {
	Base: Player | Model,
	IsPlayer: boolean,
	Player: Player?,
	Character: Model?,

	Weapons: { [number]: _Weapon },
	Perks: { [number]: _Perk },
	Info: _EntityInfo,
	
	Kill: (self: any, reason: string) -> any,

	Killed: LemonSignal.Signal<string>,
	Suicided: LemonSignal.Signal<string, string>
}



--[[ Ace Entity Info ]]--
-- info for entity instances
do local n, t = Nodes.New("EntityInfo", "Node") Nodes[n] = t :: _EntityInfoStatic end
export type _EntityInfoStatic = _NodeStatic & {
	New : (info: _EntityInfo) -> _EntityInfo,
}
export type _EntityInfo = _Node & {
	
}



--[[ Ace Weapon ]]--
-- weapons like guns or melee
do local n, t = Nodes.New("Weapon", "Node") Nodes[n] = t :: _WeaponStatic end
export type _WeaponStatic = _NodeStatic & {
	New : () -> _Weapon,
}
export type _Weapon = _Node & {
	Name : string,
	Id : string,

	Fire : (_Weapon) -> (_Projectile),
	Fired: LemonSignal.Signal<_Projectile>
}



--[[ Ace Perk ]]--
-- perk class
do local n, t = Nodes.New("Perk", "Node") Nodes[n] = t :: _PerkStatic end
export type _PerkStatic = _NodeStatic & {
	New : () -> _Perk,
}
export type _Perk = _Node & {
	Name : string,
	Id : string
}



--[[ Ace Projectile ]]--
-- projectiles fired from weapons
do local n, t = Nodes.New("Projectile", "Node") Nodes[n] = t :: _ProjectileStatic end
export type _ProjectileStatic = _NodeStatic & {
	New : () -> _Projectile,
}
export type _Projectile = _Node & {
	Name : string,
	Id: string,

	Info : _ProjectileInfo,

	Hit : LemonSignal.Signal<Part>
}



--[[ Ace Projectile Info ]]--
-- info about projectiles
do local n, t = Nodes.New("ProjectileInfo", "Node") Nodes[n] = t :: _ProjectileInfo end
export type _ProjectileInfoStatic = _NodeStatic & {
	New : (info: _ProjectileInfo) -> _ProjectileInfo,
}
export type _ProjectileInfo = _Node & {

}



--[[ Ace Explosion Info ]]--
-- info for explosion instances
do local n, t = Nodes.New("ExplosionInfo", "Node") Nodes[n] = t :: _ExplosionInfo end
Nodes.ExplosionInfo = {
	FilterType = Enum.RaycastFilterType.Exclude,
	Filter = {},

	OriginEntity = nil,

	MultiHit = false,
	FuseTime = nil,
	Knockback = true,
	KnockbackMultiplier = 5,
	Cooldown = 1,
	Velocity = 300,
	SetDamage = nil,
	FallVelocity = 1,

	Radius = 30,
	Color = nil,
	Transparency = nil,

	FireProbability = 1,
	FireInfo = nil

}
export type _ExplosionInfo = _Node & {
	FilterType : Enum.RaycastFilterType,
	Filter : { [number] : Instance },

	OriginEntity : _Entity?,
	OriginProjectile : _Projectile,

	MultiHit : boolean,
	FuseTime : number?,
	Knockback : boolean,
	KnockbackMultiplier : number,
	Cooldown : number,
	Velocity : number,
	SetDamage : number?,
	FallVelocity : number,

	Radius : number,
	Color : Color3 | BrickColor?,
	Transparency : number?,

	FireProbability : number,
	FireInfo : _FireInfo?,
}



--[[ Ace Fire Info ]]--
-- info for fire instances
do local n, t = Nodes.New("FireInfo", "Node") Nodes[n] = t :: _FireInfo end
Nodes.FireInfo = {
	Color = nil,
	Transparency = nil,

	OriginEntity = nil,

	FireProbability = 1,
	Damage = 1,
	TickTime = 1,
	TotalTime = 5,

}
export type _FireInfo = _Node & {
	Color : Color3 | BrickColor?,
	Transparency : number?,

	OriginEntity : _Entity?,

	Damage : number,
	TickTime : number,
	TotalTime : number,
}



--[[ Ace Explosion ]]--
-- big booms
do local n, t = Nodes.New("Explosion", "Node") Nodes[n] = t :: _Explosion end
export type _Explosion = _Node & {
	Info : _ExplosionInfo
}



--[[ Ace Fire ]]--
-- big burn hot
do local n, t = Nodes.New("Fire", "Node") Nodes[n] = t :: _Fire end
export type _Fire = _Node & {
	Info : _FireInfo
}




return Nodes :: NodeList