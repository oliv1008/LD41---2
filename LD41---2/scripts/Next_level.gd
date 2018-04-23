extends Node2D

export (String) var path

func _ready():
	pass


func _on_Area2D_body_enter( body ):
	if body.get_name().match("player"):
		global.clear_singleton()
		global.to_next_level()
