class_name MapHex
extends Spatial

signal on_hex_clicked(hex)
signal on_hex_cursor_enter(hex)
signal on_hex_cursor_exit(hex)

export(String) var scan_icon
export(String) var control_icon
export(String) var spawn_icon

export(Color) var base_color
export(Color) var border_color
export(Color) var highlight_color

var player_tokens := []
var enemy_tokens := []
var sector

var ShipToken = preload("res://scenes/combat/ShipToken.tscn")


func _arrange_tokens_in_a_circle():
	print("_arrange_tokens_in_a_circle() for hex ", sector.coordinates)
	var combined_tokens = player_tokens + enemy_tokens

	var count = combined_tokens.size()
	var radius = Vector3(0.7, 0, 0)
	var center = Vector3(0, 0, 0)

	var step = 2 * PI / count

	for i in range(count):
		var token_position = (center + radius).rotated(Vector3.FORWARD, step * i)
		combined_tokens[i].translation = token_position


func highlight_border(color: Color):
	$HexBorder.modulate = color
	$HexBorder.render_priority = 5


func clear_border_highlight():
	$HexBorder.modulate = border_color
	$HexBorder.render_priority = 0


func highlight_base(color: Color):
	$HexBaseColor.modulate = color


func clear_base_highlight():
	$HexBaseColor.modulate = base_color


func _handle_cursor_enter():
	emit_signal("on_hex_cursor_enter", self)


func _handle_cursor_exit():
	emit_signal("on_hex_cursor_exit", self)


func _handle_input_event(
	_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int
) -> void:
	if event.is_action_released("click"):
		emit_signal("on_hex_clicked", self)


func spawn_ship(ship: Ship):
	sector.add_ship(ship)
	var token = ShipToken.instance()
	token.display(ship)
	token.current_sector = sector
	$Ships.add_child(token)

	player_tokens.append(token)

	token.rotation = Vector3(deg2rad(90), 0, 0)

	_arrange_tokens_in_a_circle()


func display(p_sector: Sector):
	sector = p_sector

	if sector.player_scanned:
		$Markers/PlayerScanMark.visible = true
		$Markers/PlayerScanMark/Icon.text = "%s" % scan_icon

	if sector.enemy_scanned:
		$Markers/EnemyScanMark.visible = true
		$Markers/EnemyScanMark/Icon.text = "%s" % scan_icon

	if sector.is_player_spawn:
		$Markers/PlayerSpawnMark.visible = true
		$Markers/PlayerSpawnMark/Icon.text = "??? %s" % sector.spawn_for

	if sector.is_enemy_spawn:
		$Markers/EnemySpawnMark.visible = true
		$Markers/EnemySpawnMark/Icon.text = "??? %s" % sector.spawn_for

	if sector.controlled_by != null:
		$Markers/ControlMark.visible = true

		if sector.controlled_by == Enums.Actor.PLAYER:
			$Markers/ControlMark/Background.modulate = Color("#1d486e")

		if sector.controlled_by == Enums.Actor.ENEMY:
			$Markers/ControlMark/Background.modulate = Color("#7f3129")
