class_name UICard
extends Control

export(Color) var officer_card_color
export(Color) var crew_card_color
export(Color) var event_card_color
export(Color) var void_card_color

var card


func display(p_card):
	card = p_card

	$TypeInfo/Label.text = (
		"%s - %s"
		% [Enums.CardSuperType.keys()[card.super_type], Enums.CardSubType.keys()[card.sub_type]]
	)

	if card.card_name != null:
		$Title.text = card.card_name

	match card.super_type:
		Enums.CardSuperType.CREW:
			$Frame.self_modulate = crew_card_color
			$TypeInfo.color = crew_card_color
			$SquadronInfo.visible = true
			$SquadronInfo.color = crew_card_color
			$SquadronInfo/ShipIcon.texture = card.ship.token.normalized_ship_icon
			$SquadronInfo/LetterLabel.text = card.ship.ship_squadron
			$Title.text = card.ship.ship_class
		Enums.CardSuperType.EVENT:
			$Frame.self_modulate = event_card_color
			$SquadronInfo.visible = false
			$TypeInfo.color = event_card_color
		Enums.CardSuperType.OFFICER:
			$Frame.self_modulate = officer_card_color
			$SquadronInfo.visible = false
			$TypeInfo.color = officer_card_color
		Enums.CardSuperType.VOID:
			$Frame.self_modulate = void_card_color
			$SquadronInfo.visible = false
			$TypeInfo.color = void_card_color

	$Initiative/Label.text = str(card.initiative)

	if card.data != null:
		$Art.texture = load("res://assets/art/%s.png" % card.get_data_id())

	if card.sub_type == Enums.CardSubType.SHIP:
		$Art.texture = load("res://assets/art/%s.png" % card.ship.data.get_data_id())
