class_name ShipToken
extends Spatial

var LambdaImage = preload("res://assets/sprites/icons/ships/lambda.png")
var NormalizedLambdaImage = preload("res://assets/sprites/icons/ships/normalized_lambda_ship.png")

var TriangleImage = preload("res://assets/sprites/icons/ships/triangle_ship.png")

var SquareAndTriangleImage = preload("res://assets/sprites/icons/ships/square_and_triangle_ship.png")
var NormalizedSquareAndTriangleImage = preload("res://assets/sprites/icons/ships/normalized_square_and_triangle_ship.png")

var ship

var ship_icon
var normalized_ship_icon

var pulse_animation


func toggle_pulse(on: bool):
	if on:
		if pulse_animation != null:
			pulse_animation.kill()
			pulse_animation = null

		pulse_animation = get_tree().create_tween()
		pulse_animation.set_loops()
		pulse_animation.tween_property($ShipIcon, "modulate", Color.white, 0.33)
		pulse_animation.tween_property($ShipIcon, "modulate", Color.goldenrod, 0.33)

		return

	if pulse_animation != null:
		pulse_animation.kill()
		pulse_animation = null

	if ship.owner == Enums.Actor.ENEMY:
		$ShipIcon.modulate = Color.crimson

	if ship.owner == Enums.Actor.PLAYER:
		$ShipIcon.modulate = Color.dodgerblue


func display(p_ship: Ship):
	ship = p_ship
	ship.token = self

	if ship.ship_squadron != null:
		$ShipSquadron/Letter.text = ship.ship_squadron

	if ship.sub_type == Enums.ShipSubType.CORVETTE:
		ship_icon = LambdaImage
		normalized_ship_icon = NormalizedLambdaImage
	elif ship.sub_type == Enums.ShipSubType.FRIGATE:
		ship_icon = SquareAndTriangleImage
		normalized_ship_icon = NormalizedSquareAndTriangleImage
	elif ship.sub_type == Enums.ShipSubType.DESTROYER:
		# TODO: Add normalized icon
		ship_icon = TriangleImage

	$ShipIcon.texture = ship_icon

	if ship.owner == Enums.Actor.ENEMY:
		$ShipIcon.modulate = Color.crimson
		$ShipSquadron/Background.modulate = Color.firebrick

	if ship.owner == Enums.Actor.PLAYER:
		$ShipIcon.modulate = Color.dodgerblue
		$ShipSquadron/Background.modulate = Color.royalblue

		var material = SpatialMaterial.new()
		material.albedo_color = Color.lightblue
		material.emission_enabled = true
		material.emission = Color.lightblue
		material.emission_energy = 10

		$Stand.set_surface_material(0, material)
