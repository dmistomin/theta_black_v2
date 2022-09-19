class_name Ship
extends Reference

var ship_class: String
var ship_name: String
var ship_squadron: String

var shields: int
var weapon_aim: int
var weapon_damage: int
var evasion: int
var super_type
var sub_type
var owner

var actions: Array

var data: ShipData
var token


func _init(p_owner, p_data):
	owner = p_owner
	data = p_data

	for action_string in data.actions:
		var action_name = action_string.split("_")[0]
		var action_values = action_string.split("_")[1]

		match action_name:
			"attack":
				var to_hit = action_values.split(":")[0]
				var damage = action_values.split(":")[1]

				actions.append(AttackAction.new(self, int(to_hit), int(damage)))
			"scan":
				actions.append(ScanAction.new(self, int(action_values)))
			"scout":
				actions.append(ScoutAction.new(self, int(action_values)))
			"move":
				actions.append(MoveAction.new(self, int(action_values)))

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


func set_squadron(p_squadron: String):
	ship_squadron = p_squadron

	if token != null:
		token.display(self)
