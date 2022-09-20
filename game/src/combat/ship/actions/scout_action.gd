class_name ScoutAction
extends MoveAction


func _init(p_ship, p_move_value).(p_ship, p_move_value):
	move_value = p_move_value
	type = Enums.ShipActionType.SCOUT
