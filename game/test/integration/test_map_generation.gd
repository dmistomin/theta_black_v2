extends GutTest

var current_map


func before_each():
	current_map = preload("res://src/combat/map.gd").new()
	add_child_autofree(current_map)


func test_small_map():
	current_map.load_encounter(Encounter.new("test_1"))

	assert_eq(current_map.sectors.keys().size(), 7)
	assert_eq(
		current_map.sectors.keys(),
		[
			Vector2(0, 0),
			Vector2(1, 0),
			Vector2(0, 1),
			Vector2(1, 1),
			Vector2(-1, 0),
			Vector2(0, -1),
			Vector2(-1, -1),
		]
	)

	var player_start_sector = current_map.get_sector(0, 0)

	assert_true(player_start_sector.player_scanned)
	assert_false(player_start_sector.enemy_scanned)
	assert_eq(player_start_sector.controlled_by, Enums.Actor.PLAYER)
