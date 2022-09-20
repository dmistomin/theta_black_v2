class_name Map
extends Spatial

signal on_hex_focus(hex)
signal on_hex_unfocus(hex)

export(Vector2) var hex_scale

export(Color) var hex_highlight_color
export(Color) var hex_focus_color

export(bool) var hex_hover_enabled
export(bool) var hex_select_enabled

var HexGrid = preload("res://lib/godot-gdhexgrid/HexGrid.gd")
var HexCell = preload("res://lib/godot-gdhexgrid/HexCell.gd")
var MapHex = preload("res://scenes/combat/MapHex.tscn")

var hex_grid = HexGrid.new()
var sectors = {}

var focused_hex

var hexes
var selected_hexes = []
var valid_selection_hexes = []


func _handle_hex_hover_start(hex: MapHex):
	if hex == focused_hex or (not hex_hover_enabled):
		return
	hex.highlight_border(hex_highlight_color)


func _handle_hex_hover_stop(hex: MapHex):
	if hex == focused_hex or (not hex_hover_enabled):
		return
	hex.clear_border_highlight()


func _handle_hex_click(hex: MapHex):
	if not hex_select_enabled:
		return

	if focused_hex != null:
		focused_hex.clear_border_highlight()
		emit_signal("on_hex_unfocus", focused_hex)

	if focused_hex == hex:
		focused_hex = null
		return

	focused_hex = hex
	emit_signal("on_hex_focus", focused_hex)
	hex.highlight_border(hex_focus_color)


func enable_hex_selection_from_subset(list_of_valid_hexes: Array):
	for h in list_of_valid_hexes:
		valid_selection_hexes = list_of_valid_hexes
		h.highlight_border(hex_highlight_color)


func toggle_hex_hover(on: bool):
	hex_hover_enabled = on

	if not on:
		for coord in sectors.keys():
			var hex = sectors[coord].map_hex
			hex.clear_border_highlight()


func toggle_hex_select(on: bool):
	hex_select_enabled = on

	if not on:
		if focused_hex:
			focused_hex.clear_border_highlight()
			focused_hex = null


func load_map(map_name: String) -> void:
	var map_data = load("res://data/maps/%s.tres" % map_name)

	for coords in map_data.sectors:
		var hex_cell = HexCell.new(coords)
		var new_hex = MapHex.instance()
		new_hex.get_node("CoordLabel").text = ("(%s, %s)" % [coords.x, coords.y])
		add_child(new_hex)

		new_hex.connect("on_hex_cursor_enter", self, "_handle_hex_hover_start")
		new_hex.connect("on_hex_cursor_exit", self, "_handle_hex_hover_stop")
		new_hex.connect("on_hex_clicked", self, "_handle_hex_click")

		var world_pos = hex_grid.get_hex_center3(hex_cell)
		new_hex.global_translation = world_pos

		var sector = Sector.new()

		sector.coordinates = coords
		sector.cell = hex_cell
		sector.map_hex = new_hex
		new_hex.sector = sector
		sectors[coords] = sector

	for scan_levels in map_data.player_scanned_sectors:
		var coords = Vector2(scan_levels.x, scan_levels.y)
		sectors[coords].player_scanned = true
		sectors[coords].update_map()

	for scan_levels in map_data.enemy_scanned_sectors:
		var coords = Vector2(scan_levels.x, scan_levels.y)
		sectors[coords].enemy_scanned = true
		sectors[coords].update_map()


func spawn_new_token_at(ship_class: String, ship_owner, map_hex: MapHex):
	var ship_data = load("res://data/ships/%s.tres" % ship_class)
	var ship = Ship.new(ship_owner, ship_data)

	map_hex.spawn_ship(ship)

	return ship


func _ready() -> void:
	hex_grid.hex_scale = hex_scale
