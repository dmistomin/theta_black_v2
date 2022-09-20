class_name CommandCard
extends Card


func _init(p_owner, p_data).(
	p_owner,
	p_data.initiative,
	_map_super_type_str_to_enum(p_data.super_type),
	_map_sub_type_str_to_enum(p_data.sub_type),
	p_data
):
	pass
