class_name Card
extends Reference

var card_name

var initiative: int
var super_type
var sub_type
var owner

var data


func _map_super_type_str_to_enum(super_type_str):
	return Enums.CardSuperType[super_type_str.to_upper()]


func _map_sub_type_str_to_enum(sub_type_str):
	return Enums.CardSubType[sub_type_str.to_upper()]


func _init(p_owner, p_initiative, p_super_type, p_sub_type, p_data):
	owner = p_owner
	initiative = p_initiative
	super_type = p_super_type
	sub_type = p_sub_type
	data = p_data

	if data != null:
		card_name = p_data.card_name


func get_data_id():
	var split_path = data.resource_path.split(".tres")[0].split("/")
	return split_path[split_path.size() - 1]
