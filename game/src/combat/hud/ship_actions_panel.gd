class_name ShipActionsPanel
extends Control

var ShipActionPanel = preload("res://scenes/combat/hud/ShipActionPanel.tscn")

var action_mappings = {
	Enums.ShipActionType.ATTACK: "",
	Enums.ShipActionType.SCOUT: "",
	Enums.ShipActionType.SCAN: "",
}

var actions = []


func hide():
	visible = false

	for a in actions:
		a.queue_free()

	actions = []


func display_actions_for(ship):
	visible = true

	for a in ship.actions:
		var panel = ShipActionPanel.instance()

		actions.append(panel)
		add_child(panel)

		panel.get_node("ActionButton/Label").text = Enums.ShipActionType.keys()[a.type]
		panel.get_node("ActionButton/Icon").text = action_mappings[a.type]

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
