class_name SectorDetails
extends Control

var ShipDetail = preload("res://scenes/combat/hud/ShipDetail.tscn")

var player_ship_details = []
var enemy_ship_details = []


func display(hex: MapHex):
	visible = true
	$ScrollBody/Body/HexDetails/HexIcon/Coordinates.text = (
		"(%s, %s)"
		% [hex.sector.coordinates.x, hex.sector.coordinates.y]
	)

	for ps in hex.sector.player_ships:
		var ship_detail_box = ShipDetail.instance()
		ship_detail_box.get_node("Layout/ShipIcon").texture = ps.token.get_node("ShipIcon").texture
		ship_detail_box.get_node("Layout/ShipIcon").self_modulate = ps.token.get_node(
			"ShipIcon"
		).modulate
		ship_detail_box.get_node("Layout/StatLabel").text = (" %s  %s" % [ps.shields, ps.evasion])
		player_ship_details.append(ship_detail_box)
		$ScrollBody/Body/AllySection.add_child(ship_detail_box)

	for es in hex.sector.enemy_ships:
		var ship_detail_box = ShipDetail.instance()
		ship_detail_box.get_node("Layout/ShipIcon").texture = es.token.get_node("ShipIcon").texture
		ship_detail_box.get_node("Layout/ShipIcon").self_modulate = es.token.get_node(
			"ShipIcon"
		).modulate
		ship_detail_box.get_node("Layout/StatLabel").text = (" %s  %s" % [es.shields, es.evasion])
		enemy_ship_details.append(ship_detail_box)
		$ScrollBody/Body/EnemySection.add_child(ship_detail_box)


func hide():
	visible = false

	for ship_box in player_ship_details:
		ship_box.queue_free()

	for ship_box in enemy_ship_details:
		ship_box.queue_free()

	player_ship_details = []
	enemy_ship_details = []
