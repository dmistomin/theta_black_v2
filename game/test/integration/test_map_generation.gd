extends GutTest

var current_map


func before_each():
	current_map = preload("res://src/combat/map.gd").new()
	add_child_autofree(current_map)


func test_load_map():
	current_map.load_map("m1")

	assert_eq(current_map.sectors.keys().size(), 8)
	assert_eq(
		current_map.sectors.keys(),
		[
			Vector2(0, 0),
			Vector2(0, 1),
			Vector2(1, 0),
			Vector2(1, 1),
			Vector2(2, 1),
			Vector2(1, 2),
			Vector2(2, 2),
			Vector2(2, 0),
		]
	)
