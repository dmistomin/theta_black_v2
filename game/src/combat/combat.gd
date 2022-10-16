class_name Combat
extends Node

var player_deck = CardList.new()
var player_hand = []
var player_discard = CardList.new()

var enemy_deck = CardList.new()
var enemy_hand = []
var enemy_discard = CardList.new()

var current_state = Enums.CombatState.PAUSED

var _state_transitions = {
	Enums.CombatState.PAUSED: [Enums.CombatState.ANY],
	Enums.CombatState.PLAYER_TURN_UNFOCUSED:
	[Enums.CombatState.PAUSED, Enums.CombatState.PLAYER_TURN_CARD_SELECTED],
	Enums.CombatState.PLAYER_TURN_CARD_SELECTED:
	[
		Enums.CombatState.PAUSED,
		Enums.CombatState.PLAYER_TURN_UNFOCUSED,
		Enums.CombatState.PLAYER_TURN_ACTION_SELECTED
	],
	Enums.CombatState.PLAYER_TURN_ACTION_SELECTED:
	[
		Enums.CombatState.PAUSED,
		Enums.CombatState.PLAYER_TURN_CARD_SELECTED,
		Enums.CombatState.PLAYER_TURN_ACTION_RESOLVING
	],
}


func _on_request_change_state(new_state, data):
	print("request_change_state(), new_state: ", new_state)
	var prev_state = current_state

	if (
		not (new_state in _state_transitions[prev_state])
		and not (Enums.CombatState.ANY in _state_transitions[prev_state])
	):
		printerr(
			(
				"Invalid state transition! Attempted to pass from '%s' to '%s'"
				% [Enums.CombatState.keys()[prev_state], Enums.CombatState.keys()[new_state]]
			)
		)
		return

	match new_state:
		Enums.CombatState.PAUSED:
			print("Pause")
			$Map.toggle_hex_hover_fx(false)
			$Map.toggle_hex_select(false)
		Enums.CombatState.PLAYER_TURN_UNFOCUSED:
			print("Player turn - unfocused")
			$Map.toggle_hex_hover_fx(true)
			$Map.toggle_hex_select(true)
			$Map.clear_path_selection()
			$Map.clear_hex_border_fx()
			$HUD/BottomPanel/CardControls.toggle_display_card_actions_panel(false)
			$HUD/BottomPanel/CardControls.hide_action_detail()
		Enums.CombatState.PLAYER_TURN_CARD_SELECTED:
			print("Player turn - card selected")
			$HUD/BottomPanel/CardControls.toggle_display_card_actions_panel(true)
			$Map.clear_path_selection()
			$Map.clear_hex_border_fx()
			$HUD/BottomPanel/CardControls.hide_action_detail()
		Enums.CombatState.PLAYER_TURN_ACTION_SELECTED:
			print("Player turn - action selected")
			$Map.toggle_hex_hover_fx(false)
			$Map.toggle_hex_select(false)
			$HUD/SectorDetails.hide()
			data["action"].show_action_controls()
			$HUD/BottomPanel/CardControls.show_action_detail_for(data["action"])
		Enums.CombatState.PLAYER_TURN_ACTION_RESOLVING:
			print("Player turn - action resolving")
			$HUD/SectorDetails.hide()

	current_state = new_state


func _setup_actions(ship_actions: Array):
	for a in ship_actions:
		a.connect("request_change_state", self, "_on_request_change_state")

		if a.type == Enums.ShipActionType.MOVE:
			a.setup(
				$Map,
				$HUD/BottomPanel/CardControls/ActionConfirm/ButtonContainer/PrimaryButton,
				$HUD/BottomPanel/CardControls/ActionConfirm/ButtonContainer/SecondaryButton
			)
			print("move action!")
		elif a.type == Enums.ShipActionType.SCOUT:
			a.setup(
				$Map,
				$HUD/BottomPanel/CardControls/ActionConfirm/ButtonContainer/PrimaryButton,
				$HUD/BottomPanel/CardControls/ActionConfirm/ButtonContainer/SecondaryButton
			)
		else:
			print(
				"Attempted to setup unknown action type: '%s'" % Enums.ShipActionType.keys()[a.type]
			)


func _setup_game():
	var ship_1 = $Map.spawn_new_token_at(
		"s1", Enums.Actor.PLAYER, $Map.sectors[Vector2(0, 0)].map_hex
	)
	var ship_2 = $Map.spawn_new_token_at(
		"s2", Enums.Actor.PLAYER, $Map.sectors[Vector2(0, 0)].map_hex
	)

	ship_1.set_squadron("A")
	_setup_actions(ship_1.actions)

	ship_2.set_squadron("B")
	_setup_actions(ship_2.actions)

	player_deck.add_several_cards(
		[
			ShipCard.new(Enums.Actor.PLAYER, 6, ship_1),
			ShipCard.new(Enums.Actor.PLAYER, 6, ship_2),
			VoidCard.new(Enums.Actor.PLAYER),
			VoidCard.new(Enums.Actor.PLAYER),
			CommandCard.new(Enums.Actor.PLAYER, preload("res://data/cards/o1.tres"))
		]
	)
	player_deck.shuffle()

	player_hand = player_deck.draw(4)
	_on_request_change_state(Enums.CombatState.PLAYER_TURN_UNFOCUSED, null)


func start(map_name: String):
	$Map.load_map(map_name)

	$Map.connect("on_hex_focus", $HUD, "display_hex_details")
	$Map.connect("on_hex_unfocus", $HUD, "hide_hex_details")

	_setup_game()

	$HUD/BottomPanel/CardControls.connect("request_change_state", self, "_on_request_change_state")
	$HUD/BottomPanel/CardControls/ShipActions.connect(
		"request_change_state", self, "_on_request_change_state"
	)
	$HUD/BottomPanel/CardControls.draw_cards(player_hand)
