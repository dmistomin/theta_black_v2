class_name ShipToken
extends Spatial

var LambdaImage = preload("res://assets/sprites/icons/ships/lambda.png")
var TriangleImage = preload("res://assets/sprites/icons/ships/triangle_ship.png")
var SquareAndTriangleImage = preload("res://assets/sprites/icons/ships/square_and_triangle_ship.png")

var ship


func display(p_ship: Ship):
	ship = p_ship
	ship.token = self

	if ship.sub_type == Enums.ShipSubType.CORVETTE:
		$ShipIcon.texture = LambdaImage
	elif ship.sub_type == Enums.ShipSubType.FRIGATE:
		$ShipIcon.texture = SquareAndTriangleImage
	elif ship.sub_type == Enums.ShipSubType.DESTROYER:
		$ShipIcon.texture = TriangleImage

	if ship.owner == Enums.Actor.ENEMY:
		$ShipIcon.modulate = Color.crimson

	if ship.owner == Enums.Actor.PLAYER:
		$ShipIcon.modulate = Color.dodgerblue

		var material = SpatialMaterial.new()
		material.albedo_color = Color.lightblue
		material.emission_enabled = true
		material.emission = Color.lightblue
		material.emission_energy = 10

		$Stand.set_surface_material(0, material)
