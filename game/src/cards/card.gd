class_name Card
extends Reference

var card_name

var initiative: int
var super_type
var sub_type
var owner

var data
var effect


func _init(p_owner, p_data):
	pass


func get_data_id():
	var split_path = data.resource_path.split(".tres")[0].split("/")
	return split_path[split_path.size() - 1]
