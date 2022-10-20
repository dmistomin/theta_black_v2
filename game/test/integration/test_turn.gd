extends GutTest

var Combat = preload("res://scenes/combat/Combat.tscn")

var current_combat


func before_each():
	current_combat = Combat.instance()
	add_child_autofree(current_combat)


func test_cancel_action():
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
	var hud_action_confirm = current_combat.get_node("HUD/BottomPanel/CardControls/ActionConfirm")

	assert_eq(current_combat.current_state, Enums.CombatState.PLAYER_TURN_UNFOCUSED)

	assert_true(hud_card_hand.visible)
	assert_eq(hud_card_hand.get_child_count(), 4)
	assert_eq(hud_card_hand.get_child(0).card.card_name, "Signal Delay")
	assert_eq(hud_card_hand.get_child(1).card.card_name, "Fleet Commander")
	assert_eq(hud_card_hand.get_child(2).card.card_name, "Signal Delay")
	assert_eq(hud_card_hand.get_child(3).card.card_name, "Icarus")

	assert_false(hud_display_card.visible)
	assert_false(hud_active_card_bg.visible)
	assert_false(hud_card_actions.visible)
	assert_false(hud_action_confirm.visible)

	var ship_ui_card = hud_card_hand.get_child(3)

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
	assert_false(hud_action_confirm.visible)
	assert_eq(hud_card_actions.get_child_count(), 2)

	var scout_button = hud_card_actions.get_child(1)

	assert_eq(scout_button.get_node("ActionButton/Label").text, "SCOUT")

	hud_card_actions._handle_action_click(ship_ui_card.card.ship.actions[1])

	assert_eq(current_combat.current_state, Enums.CombatState.PLAYER_TURN_ACTION_SELECTED)
	assert_false(hud_card_actions.visible)
	assert_true(hud_active_card_bg.visible)
	assert_true(hud_action_confirm.visible)

	var cancel_button = hud_action_confirm.get_node("ButtonContainer/SecondaryButton")

	assert_eq(cancel_button.text, "Cancel")
	cancel_button.emit_signal("pressed")

	assert_eq(current_combat.current_state, Enums.CombatState.PLAYER_TURN_CARD_SELECTED)


func test_scout_action():
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
	var hud_action_confirm = current_combat.get_node("HUD/BottomPanel/CardControls/ActionConfirm")

	assert_eq(current_combat.current_state, Enums.CombatState.PLAYER_TURN_UNFOCUSED)

	assert_true(hud_card_hand.visible)
	assert_eq(hud_card_hand.get_child_count(), 4)
	assert_eq(hud_card_hand.get_child(0).card.card_name, "Signal Delay")
	assert_eq(hud_card_hand.get_child(1).card.card_name, "Fleet Commander")
	assert_eq(hud_card_hand.get_child(2).card.card_name, "Signal Delay")
	assert_eq(hud_card_hand.get_child(3).card.card_name, "Icarus")

	assert_false(hud_display_card.visible)
	assert_false(hud_active_card_bg.visible)
	assert_false(hud_card_actions.visible)
	assert_false(hud_action_confirm.visible)

	var ship_ui_card = hud_card_hand.get_child(3)

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
	assert_false(hud_action_confirm.visible)
	assert_eq(hud_card_actions.get_child_count(), 2)

	var map = current_combat.get_node("Map")
	assert_eq(map.hex_options_for_path.size(), 0)

	var scout_button = hud_card_actions.get_child(1)

	assert_eq(scout_button.get_node("ActionButton/Label").text, "SCOUT")

	hud_card_actions._handle_action_click(ship_ui_card.card.ship.actions[1])

	assert_eq(current_combat.current_state, Enums.CombatState.PLAYER_TURN_ACTION_SELECTED)
	assert_false(hud_card_actions.visible)
	assert_true(hud_active_card_bg.visible)
	assert_true(hud_action_confirm.visible)

	assert_eq(map.hex_options_for_path.size(), 18)
	assert_eq(map.remaining_hex_options_for_path.size(), 18)

	var first_sector_to_move_to = map.get_sector(1, 0)

	map._handle_hex_hover_start(first_sector_to_move_to.map_hex)

	assert_eq(map.hex_options_for_path.size(), 18)
	assert_eq(map.remaining_hex_options_for_path.size(), 6)
