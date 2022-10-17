extends GutTest


func test_encounter_parsing():
	var encounter = Encounter.new("test_1")

	assert_eq(encounter.map_id, "test_map_1")

	assert_eq(encounter.player_ships.size(), 2)

	assert_eq(encounter.player_ships[0].ship_class, "Icarus")
	assert_eq(encounter.player_ships[0].starting_position, Vector2(0, 0))

	assert_eq(encounter.player_ships[1].ship_class, "Medusa")
	assert_eq(encounter.player_ships[1].starting_position, Vector2(0, 1))

	assert_eq(encounter.player_deck.count(), 5)
