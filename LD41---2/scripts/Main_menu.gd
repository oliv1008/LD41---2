extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	global.check_input("jump")
	pass

func _on_Button_pressed():
	global._on_New_game_button_pressed(self)
