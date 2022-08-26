class_name Map
extends Spatial

var HexGrid = preload("res://lib/godot-gdhexgrid/HexGrid.gd")
var HexCell = preload("res://lib/godot-gdhexgrid/HexCell.gd")

var MapHex = preload("res://scenes/combat/MapHex.tscn")

var hex_grid = HexGrid.new()
var sectors = {}


func _load_map(map_name: String) -> void:
	var map_data = load("res://data/maps/%s.tres" % map_name)

	for coords in map_data.sectors:
		var new_hex = MapHex.instance()
		new_hex.get_node("CoordLabel").text = ("(%s, %s)" % [coords.x, coords.y])
		add_child(new_hex)

		var world_pos = hex_grid.get_hex_center3(HexCell.new(coords))
		new_hex.global_translation = world_pos

		var sector = Sector.new()

		sector.coordinates = coords
		sector.map_hex = new_hex
		sectors[coords] = sector

	for scan_levels in map_data.player_scanned_sectors:
		var coords = Vector2(scan_levels.x, scan_levels.y)
		sectors[coords].player_scan_level = scan_levels.z
		sectors[coords].update_map()

	for scan_levels in map_data.enemy_scanned_sectors:
		var coords = Vector2(scan_levels.x, scan_levels.y)
		sectors[coords].enemy_scan_level = scan_levels.z
		sectors[coords].update_map()


func _spawn_player_flagship_at(map_hex: MapHex):
	var flagship_data = preload("res://data/ships/s1.tres")
	var flagship = Ship.new(Enums.Actor.PLAYER, flagship_data)

	map_hex.spawn_ship(flagship)


func _ready() -> void:
	hex_grid.hex_scale = Vector2(2.5, 2.95)
	_load_map("m1")
	_spawn_player_flagship_at(sectors[Vector2(0, 0)].map_hex)
