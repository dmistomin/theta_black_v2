class_name Card
extends Reference

var card_name

var initiative: int
var super_type
var sub_type
var owner

var data


func _init(p_owner, p_initiative, p_super_type, p_sub_type, p_data):
	owner = p_owner
	initiative = p_initiative
	super_type = p_super_type
	sub_type = p_sub_type
	data = p_data


func get_data_id():
	var split_path = data.resource_path.split(".tres")[0].split("/")
	return split_path[split_path.size() - 1]
