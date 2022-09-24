class_name ShipAction
extends Reference

var type
var ship


func _init(p_type, p_ship):
	type = p_type
	ship = p_ship


func on_map_hex_path_add():
	printerr("on_map_hex_path_add() not implemented!")


func on_map_hex_path_clear():
	printerr("on_map_hex_path_delete() not implemented!")


func on_action_confirm(_data: Dictionary = {}):
	printerr("on_action_confirm() not implemented!")


func on_action_cancel(_data: Dictionary = {}):
	printerr("on_action_cancel() not implemented!")
