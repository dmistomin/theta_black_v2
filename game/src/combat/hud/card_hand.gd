class_name CardHand
extends Control

signal on_card_preview_start(card)
signal on_card_preview_stop(card)

export(bool) var popup_on_hover

var UICard = preload("res://scenes/ui/UICard.tscn")

var cards_in_hand = []


func _show_card_preview(card_in_hand):
	if not popup_on_hover:
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


func setup():
	# TODO: change to show real card data

	for i in range(4):
		var new_card = UICard.instance()
		add_child(new_card)
		cards_in_hand.append(new_card)

	for card in cards_in_hand:
		card.connect("mouse_entered", self, "_show_card_preview", [card])
