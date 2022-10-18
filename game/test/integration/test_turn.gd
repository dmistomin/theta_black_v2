extends GutTest

var Combat = preload("res://scenes/combat/Combat.tscn")

var current_combat


func before_each():
	current_combat = Combat.instance()
	add_child_autofree(current_combat)


func test_first_turn():
	current_combat.start(Encounter.new("test_2"))

	assert_eq(current_combat.player_hand.size(), 4)
	assert_eq(current_combat.player_deck.count(), 1)

	var hud_card_controls = current_combat.get_node("HUD/BottomPanel/CardControls")
	var hud_card_hand = current_combat.get_node("HUD/BottomPanel/CardControls/CardHand")
	var hud_display_card = current_combat.get_node("HUD/BottomPanel/CardControls/DisplayCard")
	var hud_active_card_bg = current_combat.get_node(
		"HUD/BottomPanel/CardControls/ActiveCardBackground"
	)
	var hud_card_actions = current_combat.get_node("HUD/BottomPanel/CardControls/CardActions")

	assert_eq(current_combat.current_state, Enums.CombatState.PLAYER_TURN_UNFOCUSED)

	assert_true(hud_card_hand.visible)
	assert_eq(hud_card_hand.get_child_count(), 4)

	assert_eq(hud_card_hand.get_child(0).card.card_name, "Fleet Commander")
	assert_eq(hud_card_hand.get_child(1).card.card_name, "Signal Delay")
	assert_eq(hud_card_hand.get_child(2).card.card_name, "Icarus")
	assert_eq(hud_card_hand.get_child(3).card.card_name, "Signal Delay")

	assert_false(hud_display_card.visible)
	assert_false(hud_active_card_bg.visible)
	assert_false(hud_card_actions.visible)

	var ship_ui_card = hud_card_hand.get_child(2)

	# TODO: Investigate a better way to simulate mouse movement. Not sure it's even possible,
	# more research needed. See GUT issue for more context: https://github.com/bitwes/Gut/issues/316
	hud_card_controls._show_card_preview(ship_ui_card)

	assert_eq(ship_ui_card.modulate.a, 0.0)
	assert_true(hud_display_card.visible)

	var click_release_event = InputFactory.action_up("click")
	hud_card_controls._toggle_display_card_on_click(click_release_event)

	assert_eq(current_combat.current_state, Enums.CombatState.PLAYER_TURN_CARD_SELECTED)

	assert_true(hud_active_card_bg.visible)
	assert_true(hud_card_actions.visible)
	assert_eq(hud_card_actions.get_child_count(), 2)
