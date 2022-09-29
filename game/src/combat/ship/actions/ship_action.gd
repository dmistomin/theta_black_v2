class_name ShipAction
extends Reference

signal request_change_state(new_state, data)

var type
var ship


func _init(p_type, p_ship):
	type = p_type
	ship = p_ship


func on_map_hex_path_add():
	pass


func on_map_hex_path_clear():
	pass


func on_map_hex_path_confirmed(_path):
	pass


func on_action_confirm(_data: Dictionary = {}):
	pass


func on_action_cancel(_data: Dictionary = {}):
	pass
