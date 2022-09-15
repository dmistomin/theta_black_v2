class_name Map
extends Spatial

signal on_hex_focus(hex)
signal on_hex_unfocus(hex)

export(Vector2) var hex_scale

export(Color) var hex_highlight_color
export(Color) var hex_focus_color

var HexGrid = preload("res://lib/godot-gdhexgrid/HexGrid.gd")
var HexCell = preload("res://lib/godot-gdhexgrid/HexCell.gd")
var MapHex = preload("res://scenes/combat/MapHex.tscn")

var hex_grid = HexGrid.new()
var sectors = {}

var focused_hex


func _handle_hex_hover_start(hex: MapHex):
	if hex == focused_hex:
		return
	hex.highlight_border(hex_highlight_color)


func _handle_hex_hover_stop(hex: MapHex):
	if hex == focused_hex:
		return
	hex.clear_border_highlight()


func _handle_hex_click(hex: MapHex):
	if focused_hex != null:
		focused_hex.clear_border_highlight()
		emit_signal("on_hex_unfocus", focused_hex)

	if focused_hex == hex:
		focused_hex = null
		return

	focused_hex = hex
	emit_signal("on_hex_focus", focused_hex)
	hex.highlight_border(hex_focus_color)


func load_map(map_name: String) -> void:
	var map_data = load("res://data/maps/%s.tres" % map_name)

	for coords in map_data.sectors:
		var new_hex = MapHex.instance()
		new_hex.get_node("CoordLabel").text = ("(%s, %s)" % [coords.x, coords.y])
		add_child(new_hex)

		new_hex.connect("on_hex_cursor_enter", self, "_handle_hex_hover_start")
		new_hex.connect("on_hex_cursor_exit", self, "_handle_hex_hover_stop")
		new_hex.connect("on_hex_clicked", self, "_handle_hex_click")

		var world_pos = hex_grid.get_hex_center3(HexCell.new(coords))
		new_hex.global_translation = world_pos

		var sector = Sector.new()

		sector.coordinates = coords
		sector.map_hex = new_hex
		new_hex.sector = sector
		sectors[coords] = sector

	for scan_levels in map_data.player_scanned_sectors:
		var coords = Vector2(scan_levels.x, scan_levels.y)
		sectors[coords].player_scan_level = scan_levels.z
		sectors[coords].update_map()

	for scan_levels in map_data.enemy_scanned_sectors:
		var coords = Vector2(scan_levels.x, scan_levels.y)
		sectors[coords].enemy_scan_level = scan_levels.z
		sectors[coords].update_map()


func spawn_new_token_at(ship_class: String, ship_owner, map_hex: MapHex):
	var ship_data = load("res://data/ships/%s.tres" % ship_class)
	var ship = Ship.new(ship_owner, ship_data)

	map_hex.spawn_ship(ship)


func _ready() -> void:
	hex_grid.hex_scale = hex_scale
