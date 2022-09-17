class_name CardControls
extends Control

export(bool) var hover_enabled


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
	$DisplayCard.visible = false

	for c in $CardHand.get_children():
		c.modulate.a = 1.0
		c.mouse_filter = MOUSE_FILTER_STOP


func _toggle_display_card_on_click(event: InputEvent):
	if event.is_action_released("click"):
		$ActiveCardBackground.visible = true
		$DisplayCard.disconnect("mouse_exited", self, "_stop_showing_card_preview")
		$DisplayCard.rect_global_position = $ActiveCardBackground/ActiveCardPosition.rect_global_position


func setup():
	$DisplayCard.connect("mouse_exited", self, "_stop_showing_card_preview")
	$DisplayCard.connect("gui_input", self, "_toggle_display_card_on_click")

	$CardHand.setup()
