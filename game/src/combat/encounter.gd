class_name Encounter
extends Reference

var map_id: String

var player_ships := []
var player_spawns := []
var player_deck: CardList

var enemy_ships := []
var enemy_spawns := []
var enemy_deck: CardList

var _encounter_data = {
	"test_1":
	{
		"map_id": "test_map_1",
		"player_deck":
		[
			{"id": "s1", "pos": Vector2(0, 0), "squadron": "A"},
			{"id": "s2", "pos": Vector2(0, 1), "squadron": "B"},
			{"id": "v1"},
			{"id": "v1"},
			{"id": "o1"}
		],
		"player_spawns":
		[{"pos": Vector2(0, 0), "squadron": "*"}, {"pos": Vector2(0, 1), "squadron": "B"}],
		"enemy_ships": [],
		"enemy_deck": [],
		"enemy_spawns": []
	},
	"basic":
	{
		"map_id": "m1",
		"player_deck":
		[
			{"id": "s1", "pos": Vector2(0, 0), "squadron": "A"},
			{"id": "s2", "pos": Vector2(0, 0), "squadron": "B"},
			{"id": "v1"},
			{"id": "v1"},
			{"id": "o1"}
		],
		"player_spawns": [{"pos": Vector2(0, 0), "squadron": "*"}],
		"enemy_ships": [],
		"enemy_deck": [],
		"enemy_spawns": [{"pos": Vector2(2, 2), "squadron": "*"}],
	},
	"test": {}
}


func _initialize_variables_for_encounter(encounter_id):
	var data = _encounter_data[encounter_id]

	map_id = data["map_id"]

	enemy_spawns = data["enemy_spawns"]

	player_spawns = data["player_spawns"]
	player_deck = CardList.new()

	for c in data["player_deck"]:
		if c["id"][0] == "s":
			var ship_data = load("res://data/ships/%s.tres" % c["id"])
			var new_ship = Ship.new(Enums.Actor.PLAYER, ship_data)

			new_ship.ship_squadron = c["squadron"]
			new_ship.starting_position = c["pos"]

			player_ships.append(new_ship)
			# TODO: Move initative into ship attributes
			player_deck.add_one_card(ShipCard.new(Enums.Actor.PLAYER, 6, new_ship))
		elif c["id"][0] == "v":
			player_deck.add_one_card(VoidCard.new(Enums.Actor.PLAYER))
		elif c["id"][0] == "o":
			player_deck.add_one_card(
				CommandCard.new(Enums.Actor.PLAYER, load("res://data/cards/%s.tres" % c["id"]))
			)


func _init(encounter_id):
	if not (encounter_id in _encounter_data):
		printerr("Unknown encounter_id '%s'! Could not load encounter" % encounter_id)
		return

	_initialize_variables_for_encounter(encounter_id)
