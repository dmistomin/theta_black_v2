class_name ShipToken
extends Spatial

var FlagshipImage = preload("res://assets/sprites/icons/capital_ship.png")
var TriangleImage = preload("res://assets/sprites/icons/triangle_ship.png")
var SquareAndTriangleImage = preload("res://assets/sprites/icons/square_and_triangle_ship.png")

var ship


func display(p_ship: Ship):
	ship = p_ship

	if ship.type == Enums.ShipType.FLAGSHIP:
		$ShipIcon.texture = FlagshipImage

	if ship.owner == Enums.Actor.PLAYER:
		$ShipIcon.modulate = Color.dodgerblue

		var material = SpatialMaterial.new()
		material.albedo_color = Color.lightblue
		material.emission_enabled = true
		material.emission = Color.lightblue
		material.emission_energy = 10

		$Stand.set_surface_material(0, material)
