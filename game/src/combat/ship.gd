class_name Ship
extends Reference

var ship_class: String
var ship_name: String

var shields: int
var weapon_aim: int
var weapon_damage: int
var evasion: int
var super_type
var sub_type
var owner

var data: ShipData
var token


func _init(p_owner, p_data):
	owner = p_owner
	data = p_data

	ship_class = data.ship_class
	shields = data.shields
	weapon_aim = data.weapon_aim
	weapon_damage = data.weapon_damage
	evasion = data.evasion

	match data.super_type:
		"scout":
			super_type = Enums.ShipSuperType.SCOUT
		"cruiser":
			super_type = Enums.ShipSuperType.CRUISER
		"capital_ship":
			super_type = Enums.ShipSuperType.CAPITAL_SHIP

	match data.sub_type:
		"corvette":
			sub_type = Enums.ShipSubType.CORVETTE
		"frigate":
			sub_type = Enums.ShipSubType.FRIGATE
		"destroyer":
			sub_type = Enums.ShipSubType.DESTROYER
		"light_cruiser":
			sub_type = Enums.ShipSubType.LIGHT_CRUISER
		"heavy_cruiser":
			sub_type = Enums.ShipSubType.HEAVY_CRUISER
		"battle_cruiser":
			sub_type = Enums.ShipSubType.BATTLE_CRUISER
		"battleship":
			sub_type = Enums.ShipSubType.BATTLESHIP
		"dreadnought":
			sub_type = Enums.ShipSubType.DREADNOUGHT
		"carrier":
			sub_type = Enums.ShipSubType.CARRIER
		_:
			printerr(
				"No match on ship type '%s' for ship class '%s'!" % [data.sub_type, data.ship_class]
			)
