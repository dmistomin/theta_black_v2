class_name Map
extends Spatial

var HexGrid = preload("res://lib/godot-gdhexgrid/HexGrid.gd")
var HexCell = preload("res://lib/godot-gdhexgrid/HexCell.gd")

var MapHex = preload("res://scenes/combat/Hex.tscn")

var hex_grid = HexGrid.new()


func _ready() -> void:
	for x in range(0, 10):
		for y in range(0, 10):
			var new_hex = MapHex.instance()
			new_hex.scale = Vector3(0.375, 0.375, 0.375)
			add_child(new_hex)

			var world_pos = hex_grid.get_hex_center3(HexCell.new(Vector2(x, y)))
			print("worls_pos: ", world_pos)
			new_hex.global_translation = world_pos
