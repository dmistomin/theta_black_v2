class_name Combat
extends Node


func _ready() -> void:
	$Map.load_map("m1")
	$Map.spawn_new_token_at("s1", Enums.Actor.PLAYER, $Map.sectors[Vector2(0, 0)].map_hex)
	$Map.spawn_new_token_at("s2", Enums.Actor.PLAYER, $Map.sectors[Vector2(0, 0)].map_hex)
	$Map.spawn_new_token_at("s3", Enums.Actor.ENEMY, $Map.sectors[Vector2(0, 0)].map_hex)
	$Map.spawn_new_token_at("s2", Enums.Actor.ENEMY, $Map.sectors[Vector2(0, 0)].map_hex)
