class_name ShipCard
extends Card

var ship


func _init(p_owner, p_initiative, p_ship).(
	p_owner, p_initiative, Enums.CardSuperType.CREW, Enums.CardSubType.SHIP, null
):
	card_name = p_ship.ship_class
	ship = p_ship
