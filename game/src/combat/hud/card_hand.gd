class_name CardHand
extends Control

signal on_card_preview_start(card)
signal on_card_preview_stop(card)

export(bool) var popup_on_hover

var UICard = preload("res://scenes/ui/UICard.tscn")

var cards_in_hand = []
var popup_card


func _show_card_preview(card_in_hand):
	if not popup_on_hover:
		return

	_stop_showing_card_preview()

	card_in_hand.modulate.a = 0
	card_in_hand.mouse_filter = MOUSE_FILTER_IGNORE

	popup_card.visible = true
	popup_card.rect_global_position = get_parent().get_node(
		"DefaultCardPosition"
	).rect_global_position
	popup_card.rect_global_position.x = card_in_hand.rect_global_position.x


func _stop_showing_card_preview():
	popup_card.visible = false

	for c in get_children():
		c.modulate.a = 1.0
		c.mouse_filter = MOUSE_FILTER_STOP


func setup(p_popup_card):
	popup_on_hover = true
	popup_card = p_popup_card
	popup_card.connect("mouse_exited", self, "_stop_showing_card_preview")

	# TODO: change to show real card data

	for i in range(4):
		var new_card = UICard.instance()
		add_child(new_card)
		cards_in_hand.append(new_card)

	for card in cards_in_hand:
		card.connect("mouse_entered", self, "_show_card_preview", [card])
