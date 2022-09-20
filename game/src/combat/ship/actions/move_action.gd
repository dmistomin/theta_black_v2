class_name MoveAction
extends ShipAction

var move_value: int


func _init(p_ship, p_move_value).(Enums.ShipActionType.MOVE, p_ship):
	move_value = p_move_value


func show_action_controls(map):
	var map_cells_in_range = ship.token.current_sector.cell.get_all_within(move_value)
	var valid_move_targets = []

	for cell in map_cells_in_range:
		var coords = cell.axial_coords

		if coords in map.sectors:
			var sector = map.sectors[coords]

			if sector != null:
				valid_move_targets.append(sector.map_hex)

	valid_move_targets.erase(ship.token.current_sector.map_hex)
	print("valid_move_targets.size(): ", valid_move_targets.size())
	map.enable_hex_selection_from_subset(valid_move_targets)
