class_name Ship
extends Reference

var name: String

var mass: int
var shields: int
var attack: int
var defense: int
var type
var owner

var data: ShipData


func _init(p_owner, p_data):
	owner = p_owner
	data = p_data

	mass = data.mass
	shields = data.shields
	attack = data.attack
	defense = data.defense

	match data.type:
		"corvette":
			type = Enums.ShipType.CORVETTE
		"frigate":
			type = Enums.ShipType.FRIGATE
		"destroyer":
			type = Enums.ShipType.DESTROYER
		"cruiser":
			type = Enums.ShipType.CRUISER
		"battleship":
			type = Enums.ShipType.BATTLESHIP
		"dreadnought":
			type = Enums.ShipType.DREADNOUGHT
		"carrier":
			type = Enums.ShipType.CARRIER
		"flagship":
			type = Enums.ShipType.FLAGSHIP
		_:
			printerr("No match on ship type!")
