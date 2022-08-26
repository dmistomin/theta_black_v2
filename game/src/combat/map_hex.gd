class_name MapHex
extends Spatial

export(String) var scan_icon
export(String) var control_icon
export(String) var spawn_icon

var player_tokens := []
var enemy_tokens := []

var ShipToken = preload("res://scenes/combat/ShipToken.tscn")


func _arrange_tokens_in_a_circle():
	var combined_tokens = player_tokens + enemy_tokens

	var count = combined_tokens.size()
	var radius = Vector3(0.66, 0, 0)
	var center = Vector3(0, 0, 0)

	var step = 2 * PI / count

	for i in range(count):
		var token_position = (center + radius).rotated(Vector3.UP, step * i)
		combined_tokens[i].translation = token_position


func spawn_ship(ship: Ship):
	var token = ShipToken.instance()
	token.display(ship)
	$Ships.add_child(token)

	player_tokens.append(token)

	token.rotation = Vector3(deg2rad(90), 0, 0)

	_arrange_tokens_in_a_circle()


func display(sector: Sector):
	if sector.player_scan_level > 0:
		$Markers/PlayerScanMark.visible = true
		$Markers/PlayerScanMark/Icon.text = "%s %s" % [scan_icon, sector.player_scan_level]

	if sector.enemy_scan_level > 0:
		$Markers/EnemyScanMark.visible = true
		$Markers/EnemyScanMark/Icon.text = "%s %s" % [scan_icon, sector.enemy_scan_level]
