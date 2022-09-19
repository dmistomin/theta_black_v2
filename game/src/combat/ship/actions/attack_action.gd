class_name AttackAction
extends ShipAction

var to_hit_modifier
var damage


func _init(p_ship, p_to_hit_modifier, p_damage).(Enums.ShipActionType.ATTACK, p_ship):
	to_hit_modifier = p_to_hit_modifier
	damage = p_damage
