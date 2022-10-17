class_name Game
extends Node


func _ready() -> void:
	$Combat.start(Encounter.new("basic"))
