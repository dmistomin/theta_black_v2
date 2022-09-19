class_name Combat
extends Node

var player_deck = CardList.new()
var player_hand = []
var player_discard = CardList.new()

var enemy_deck = CardList.new()
var enemy_hand = []
var enemy_discard = CardList.new()


func _setup_game():
	var ship_1 = $Map.spawn_new_token_at(
		"s1", Enums.Actor.PLAYER, $Map.sectors[Vector2(0, 0)].map_hex
	)
	ship_1.set_squadron("A")
	var ship_2 = $Map.spawn_new_token_at(
		"s2", Enums.Actor.PLAYER, $Map.sectors[Vector2(0, 0)].map_hex
	)
	ship_2.set_squadron("B")

	player_deck.add_several_cards(
		[
			ShipCard.new(Enums.Actor.PLAYER, 6, ship_1),
			ShipCard.new(Enums.Actor.PLAYER, 6, ship_2),
			VoidCard.new(Enums.Actor.PLAYER),
			VoidCard.new(Enums.Actor.PLAYER),
		]
	)
	player_deck.shuffle()

	player_hand = player_deck.draw(4)


func _ready() -> void:
	$Map.load_map("m1")

	#$Map.spawn_new_token_at("s1", Enums.Actor.PLAYER, $Map.sectors[Vector2(0, 0)].map_hex)
	#$Map.spawn_new_token_at("s2", Enums.Actor.PLAYER, $Map.sectors[Vector2(0, 0)].map_hex)
	#$Map.spawn_new_token_at("s3", Enums.Actor.ENEMY, $Map.sectors[Vector2(0, 0)].map_hex)
	#$Map.spawn_new_token_at("s2", Enums.Actor.ENEMY, $Map.sectors[Vector2(0, 0)].map_hex)

	$Map.connect("on_hex_focus", $HUD, "display_hex_details")
	$Map.connect("on_hex_unfocus", $HUD, "hide_hex_details")

	_setup_game()
	$HUD/BottomPanel/CardControls.draw_cards(player_hand)
