class_name CardControls
extends Control

signal request_change_state(new_state, data)

export(bool) var hover_enabled
export(bool) var display_card_locked

var UICard = preload("res://scenes/ui/UICard.tscn")
var cards_in_hand = []
var current_action


func toggle_display_card_actions_panel(on: bool):
	if on:
		display_card_locked = true
		hover_enabled = false
		_toggle_hand(false)
		$ActiveCardBackground.visible = true
		$DisplayCard.rect_global_position = $ActiveCardBackground/ActiveCardPosition.rect_global_position
		$CardHeader/Label.text = "ACTIONS"
		$ShipActions.visible = true

		if $DisplayCard.card and $DisplayCard.card.super_type == Enums.CardSuperType.CREW:
			$DisplayCard.card.ship.token.toggle_pulse(true)
			$ShipActions.display_actions_for($DisplayCard.card.ship)

		return

	display_card_locked = false
	hover_enabled = true
	$DisplayCard.visible = false
	$ActiveCardBackground.visible = false
	_toggle_hand(true)
	_reset_cards_in_hand()
	$CardHeader/Label.text = "CARDS"
	$ShipActions.clear_and_hide()

	if $DisplayCard.card and $DisplayCard.card.super_type == Enums.CardSuperType.CREW:
		$DisplayCard.card.ship.token.toggle_pulse(false)


func show_action_detail_for(action):
	current_action = action
	$ShipActions.clear_and_hide()

	if action is ShipAction:
		$CardHeader.visible = false
		$ActionConfirm.visible = true

	if action is ScoutAction:
		$ActionConfirm/HeaderLabel.text = "Scout"
		$ActionConfirm/DetailLabel.text = "Drag to set movement path, click on ending hex, and then hit the 'confirm' button."

		$ActionConfirm/ButtonContainer/PrimaryButton.text = "Confirm"
		$ActionConfirm/ButtonContainer/PrimaryButton.connect("pressed", action, "on_action_confirm")

		$ActionConfirm/ButtonContainer/SecondaryButton.text = "Cancel"
		$ActionConfirm/ButtonContainer/SecondaryButton.connect(
			"pressed", action, "on_action_cancel"
		)

		if action.map:
			$ActionConfirm/ButtonContainer/PrimaryButton.disabled = action.map.path_confirmed
			action.map.connect("on_path_confirmed", action, "on_map_hex_path_confirmed")


func hide_action_detail():
	$CardHeader.visible = true
	$ActionConfirm.visible = false

	var primary_button = $ActionConfirm/ButtonContainer/PrimaryButton
	var secondary_button = $ActionConfirm/ButtonContainer/SecondaryButton

	for c in primary_button.get_incoming_connections():
		primary_button.disconnect(c.signal_name, primary_button, c.method_name)

	for c in secondary_button.get_incoming_connections():
		secondary_button.disconnect(c.signal_name, secondary_button, c.method_name)


func _toggle_hand(on: bool):
	for c in $CardHand.get_children():
		c.visible = on


func _reset_cards_in_hand():
	for c in $CardHand.get_children():
		c.modulate.a = 1.0
		c.mouse_filter = MOUSE_FILTER_STOP


func _show_card_preview(card_in_hand):
	if not hover_enabled:
		return

	_stop_showing_card_preview()

	card_in_hand.modulate.a = 0
	card_in_hand.mouse_filter = MOUSE_FILTER_IGNORE

	$DisplayCard.display(card_in_hand.card)
	$DisplayCard.visible = true
	$DisplayCard.rect_global_position = $DefaultCardPosition.rect_global_position
	$DisplayCard.rect_global_position.x = card_in_hand.rect_global_position.x

	if card_in_hand.card.super_type == Enums.CardSuperType.CREW:
		card_in_hand.card.ship.token.toggle_pulse(true)


func _stop_showing_card_preview():
	if display_card_locked:
		return

	$DisplayCard.visible = false

	if $DisplayCard.card != null and $DisplayCard.card.super_type == Enums.CardSuperType.CREW:
		$DisplayCard.card.ship.token.toggle_pulse(false)

	_reset_cards_in_hand()


func _toggle_display_card_on_click(event: InputEvent):
	if event.is_action_released("click"):
		if display_card_locked:
			emit_signal("request_change_state", Enums.CombatState.PLAYER_TURN_UNFOCUSED, null)
		else:
			emit_signal(
				"request_change_state",
				Enums.CombatState.PLAYER_TURN_CARD_SELECTED,
				{"card": $DisplayCard.card}
			)


func draw_cards(list_of_cards):
	for c in list_of_cards:
		var new_card = UICard.instance()
		new_card.display(c)
		$CardHand.add_child(new_card)
		cards_in_hand.append(new_card)
		new_card.connect("mouse_entered", self, "_show_card_preview", [new_card])


func setup():
	$DisplayCard.connect("mouse_exited", self, "_stop_showing_card_preview")
	$DisplayCard.connect("gui_input", self, "_toggle_display_card_on_click")
