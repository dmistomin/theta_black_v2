class_name MoveAction
extends ShipAction

var map
var confirm_button
var cancel_button

var move_value: int


func _init(p_ship, p_move_value).(Enums.ShipActionType.MOVE, p_ship):
	move_value = p_move_value


func setup(p_map, p_confirm_button, p_cancel_button):
	map = p_map

	confirm_button = p_confirm_button
	cancel_button = p_cancel_button


func show_action_controls():
	var map_cells_in_range = ship.token.current_sector.cell.get_all_within(move_value)
	var valid_move_targets = []

	for cell in map_cells_in_range:
		var coords = cell.axial_coords

		if coords in map.sectors:
			var sector = map.sectors[coords]

			if sector != null:
				valid_move_targets.append(sector.map_hex)

	valid_move_targets.erase(ship.token.current_sector.map_hex)
	map.toggle_path_selection(move_value, ship.token.current_sector.map_hex, valid_move_targets)

	confirm_button.text = "Confirm"
	confirm_button.connect("pressed", self, "on_action_confirm")
	cancel_button.text = "Cancel"
	cancel_button.connect("pressed", self, "on_action_cancel")


func hide_action_controls():
	confirm_button.disconnect("pressed", self, "on_action_confirm")
	cancel_button.disconnect("pressed", self, "on_action_cancel")


func on_action_confirm(_data: Dictionary = {}):
	if map.path_confirmed:
		ship.token.move_along_path(map.path)
		emit_signal("request_change_state", Enums.CombatState.PLAYER_TURN_UNFOCUSED, null)


func on_action_cancel(_data: Dictionary = {}):
	hide_action_controls()
	emit_signal(
		"request_change_state", Enums.CombatState.PLAYER_TURN_ACTION_SELECTED, {"action": self}
	)
