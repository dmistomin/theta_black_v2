class_name CardActions
extends Control

signal request_change_state(new_state, data)

var ShipActionPanel = preload("res://scenes/combat/hud/ShipActionPanel.tscn")

var action_mappings = {
	Enums.ShipActionType.ATTACK: "",
	Enums.ShipActionType.SCOUT: "",
	Enums.ShipActionType.SCAN: "",
}

var actions = []
var current_action


func _handle_action_click(clicked_action):
	print("_handle_action_click()")
	current_action = clicked_action
	emit_signal(
		"request_change_state",
		Enums.CombatState.PLAYER_TURN_ACTION_SELECTED,
		{"action": clicked_action}
	)


func clear_and_hide():
	visible = false

	for a in actions:
		a.queue_free()

	actions = []
	current_action = null


func display_actions_for(card):
	visible = true

	if card.ship == null:
		print("Returning early from action panel for card, not a ship card")
		return

	for a in card.ship.actions:
		var panel = ShipActionPanel.instance()

		actions.append(panel)
		add_child(panel)

		panel.get_node("ActionButton/Label").text = Enums.ShipActionType.keys()[a.type]
		panel.get_node("ActionButton/Icon").text = action_mappings[a.type]
		panel.get_node("ActionButton").connect("pressed", self, "_handle_action_click", [a])

		match a.type:
			Enums.ShipActionType.ATTACK:
				panel.get_node("Description").text = (
					"Attack an opposing ship with +%s modifier to hit and deal %s damage"
					% [a.to_hit_modifier, a.damage]
				)
			Enums.ShipActionType.SCOUT:
				panel.get_node("Description").text = (
					"Move ship %s hexes while changing those hexes to 'scouted'"
					% a.move_value
				)
			Enums.ShipActionType.SCAN:
				panel.get_node("Description").text = (
					"Change %s hexes around ship to 'scouted'"
					% a.move_value
				)
