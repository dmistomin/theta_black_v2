class_name Sector
extends Reference

var coordinates: Vector2
var cell
var map_hex

var player_scan_level: int
var enemy_scan_level: int
var player_ships: Array
var enemy_ships: Array
var counters: Array


func update_map():
	if map_hex != null:
		map_hex.display(self)
