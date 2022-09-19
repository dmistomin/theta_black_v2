class_name VoidCard
extends Card


func _init(p_owner).(
	p_owner,
	0,
	Enums.CardSuperType.VOID,
	Enums.CardSubType.VOID,
	preload("res://data/cards/v1.tres")
):
	card_name = "Signal Delay"
