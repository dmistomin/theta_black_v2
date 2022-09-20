class_name HUD
extends Control

var hex_click_enabled


func display_hex_details(hex: MapHex):
	$SectorDetails.display(hex)


func hide_hex_details(_hex: MapHex):
	$SectorDetails.hide()


func _ready():
	$BottomPanel/CardControls.setup()
