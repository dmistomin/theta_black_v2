extends GutTest

var Combat = preload("res://scenes/combat/Combat.tscn")

var current_combat


func before_each():
	current_combat = Combat.instance()
	add_child_autofree(current_combat)


func test_combat_start():
	current_combat.start("test_map_1")

	assert_eq(current_combat.player_hand.size(), 4)
	assert_eq(current_combat.player_deck.count(), 1)

	assert_eq(current_combat.current_state, Enums.CombatState.PLAYER_TURN_UNFOCUSED)
