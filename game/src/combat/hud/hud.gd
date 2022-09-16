class_name HUD
extends Control


func display_hex_details(hex: MapHex):
	$SectorDetails.display(hex)


func hide_hex_details(_hex: MapHex):
	$SectorDetails.hide()


func _ready():
	$BottomPanel/CardControls.setup()
