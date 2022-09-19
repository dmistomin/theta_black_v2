class_name ShipData
extends Resource

export(String) var ship_class

export(int) var crew_hp
export(int) var shields
export(int) var weapon_aim
export(int) var weapon_damage
export(int) var evasion

export(String) var super_type
export(String) var sub_type

export(Array, String) var actions


func get_data_id():
	var split_path = resource_path.split(".tres")[0].split("/")
	return split_path[split_path.size() - 1]
