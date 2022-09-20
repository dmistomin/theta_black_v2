class_name Sector
extends Reference

var coordinates: Vector2
var cell
var map_hex

var player_scanned: bool
var enemy_scanned: bool
var player_ships: Array
var enemy_ships: Array
var counters: Array


func add_ship(new_ship: Ship):
	if new_ship.owner == Enums.Actor.PLAYER:
		player_ships.append(new_ship)

	if new_ship.owner == Enums.Actor.ENEMY:
		enemy_ships.append(new_ship)


func update_map():
	if map_hex != null:
		map_hex.display(self)
