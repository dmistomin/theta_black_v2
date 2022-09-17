class_name CardControls
extends Control

export(bool) var hover_enabled
export(bool) var display_card_locked

var UICard = preload("res://scenes/ui/UICard.tscn")
var cards_in_hand = []


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

	$DisplayCard.visible = true
	$DisplayCard.rect_global_position = $DefaultCardPosition.rect_global_position
	$DisplayCard.rect_global_position.x = card_in_hand.rect_global_position.x


func _stop_showing_card_preview():
	if display_card_locked:
		return

	$DisplayCard.visible = false

	_reset_cards_in_hand()


func _toggle_display_card_on_click(event: InputEvent):
	if event.is_action_released("click"):
		if display_card_locked:
			display_card_locked = false
			hover_enabled = true
			$DisplayCard.visible = false
			$ActiveCardBackground.visible = false
			_toggle_hand(true)
			_reset_cards_in_hand()
			$CardHeader/Label.text = "CARDS"
		else:
			display_card_locked = true
			hover_enabled = false
			_toggle_hand(false)
			$ActiveCardBackground.visible = true
			$DisplayCard.rect_global_position = $ActiveCardBackground/ActiveCardPosition.rect_global_position
			$CardHeader/Label.text = "ACTIONS"


func setup():
	$DisplayCard.connect("mouse_exited", self, "_stop_showing_card_preview")
	$DisplayCard.connect("gui_input", self, "_toggle_display_card_on_click")

	for i in range(4):
		var new_card = UICard.instance()
		$CardHand.add_child(new_card)
		cards_in_hand.append(new_card)

	for card in $CardHand.get_children():
		card.connect("mouse_entered", self, "_show_card_preview", [card])
