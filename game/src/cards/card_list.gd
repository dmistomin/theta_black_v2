class_name CardList
extends Reference

var _cards: Array = []


func count():
	return _cards.size()


func as_array():
	return _cards.duplicate()


func shuffle():
	_cards.shuffle()


func draw(num_to_draw: int) -> Array:
	var cards_to_return = []

	for _i in range(0, num_to_draw):
		var drawn_card = _cards.pop_back()

		if drawn_card != null:
			cards_to_return.append(drawn_card)

	return cards_to_return


func draw_one() -> Card:
	return draw(1)[0]


func add_one_card(card: Card):
	_cards.append(card)


func add_several_cards(cards_to_add: Array):
	for c in cards_to_add:
		add_one_card(c)


func clear():
	_cards = []
