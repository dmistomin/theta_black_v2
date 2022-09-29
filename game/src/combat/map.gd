class_name Map
extends Spatial

signal on_hex_focus(hex)
signal on_hex_unfocus(hex)
signal on_hex_hover_start(hex)
signal on_hex_hover_stop(hex)

signal on_add_to_path(added_hex, path)
signal on_clear_path(path)
signal on_path_confirmed(path)

export(Vector2) var hex_scale

export(Color) var hex_highlight_color
export(Color) var hex_focus_color

export(bool) var hex_hover_enabled
export(bool) var hex_hover_fx_enabled
export(bool) var hex_select_enabled

var HexGrid = preload("res://lib/godot-gdhexgrid/HexGrid.gd")
var HexCell = preload("res://lib/godot-gdhexgrid/HexCell.gd")
var MapHex = preload("res://scenes/combat/MapHex.tscn")

var hex_grid = HexGrid.new()
var sectors = {}

var focused_hex

var path_confirmed = false
var path = []
var path_origin
var max_path_length
var hex_options_for_path = []
var remaining_hex_options_for_path = []


func _reset_path():
	for h in path:
		h.clear_base_highlight()
		remaining_hex_options_for_path = hex_options_for_path
	emit_signal("on_clear_path", path)
	path = []


func _handle_attempted_path_drag_start(hex: MapHex):
	if path_confirmed:
		return

	if not (hex in hex_options_for_path):
		_reset_path()

	var last_hex = null

	if path.size() > 0:
		last_hex = path[path.size() - 1]

	var is_valid_hex = hex in remaining_hex_options_for_path
	var is_already_selected = hex in path
	var adjacent_to_prev = (
		(last_hex == null and hex.sector.cell.distance_to(path_origin.sector.cell) < 2)
		or (last_hex != null and hex.sector.cell.distance_to(last_hex.sector.cell) < 2)
	)

	if (
		is_valid_hex
		and (not is_already_selected)
		and adjacent_to_prev
		and path.size() < max_path_length
	):
		hex.highlight_base(Color.darkgray)
		emit_signal("on_add_to_path", hex, path)
		path.append(hex)


func _handle_path_confirm():
	path_confirmed = true
	emit_signal("on_path_confirmed", path)


func _handle_hex_hover_start(hex: MapHex):
	if hex == focused_hex:
		return
	emit_signal("on_hex_hover_start", hex)

	if hex_hover_fx_enabled:
		hex.highlight_border(hex_highlight_color)

	if hex_options_for_path.size() > 0:
		_handle_attempted_path_drag_start(hex)


func _handle_hex_hover_stop(hex: MapHex):
	if hex == focused_hex:
		return
	emit_signal("on_hex_hover_stop", hex)

	if hex_hover_fx_enabled:
		hex.clear_border_highlight()


func _handle_hex_click(hex: MapHex):
	var valid_path_selected = path.size() > 0 and (hex in hex_options_for_path) and (hex in path)
	var path_origin_should_reset = path_confirmed and path_origin == hex

	if path_origin_should_reset:
		path_confirmed = false
		_reset_path()

	if valid_path_selected:
		_handle_path_confirm()

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


func toggle_path_selection(p_max_path_length, origin, allowed_hexes):
	path_origin = origin
	max_path_length = p_max_path_length

	for h in allowed_hexes:
		hex_options_for_path = allowed_hexes
		remaining_hex_options_for_path = hex_options_for_path
		h.highlight_border(hex_highlight_color)


func clear_path_selection():
	for h in path:
		h.clear_base_highlight()

	emit_signal("on_clear_path", path)

	path = []
	remaining_hex_options_for_path = []
	hex_options_for_path = []
	path_origin = null
	max_path_length = null


func clear_hex_border_fx():
	for coord in sectors.keys():
		var hex = sectors[coord].map_hex
		hex.clear_border_highlight()


func toggle_hex_hover_fx(on: bool):
	hex_hover_fx_enabled = on

	if not on:
		clear_hex_border_fx()


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
