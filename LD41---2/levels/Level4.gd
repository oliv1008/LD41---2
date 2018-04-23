extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var letters = "JUMP100 DASH100 WALLJUMP"
	for l in letters:
		global.add_letter(l)
	nc.post_notification("letters_of_player_modified", null)

func _on_Debut_body_enter( body ):
	if body.get_name().match("player") :
		nc.post_notification("commamsg", ",   :  After escaping from this place I hope we will finally be able to live together ")


func _on_Famility_body_enter( body ):
	if body.get_name().match("player") :
		nc.post_notification("commamsg", ",   :  I also hope that we will be able to start a family, can't stop thinking about the little SEMICOLON that we'll maybe have one day ! x) ")


func _on_Famility1_body_enter( body ):
	if body.get_name().match("player") :
		nc.post_notification("commamsg", ",   :  You didn't tell me anything today, you seems worried ? Are you ok ?")

func _on_Famility2_body_enter( body ):
	if body.get_name().match("player") :
		nc.post_notification("commamsg", ",   :  I'm so happy that we'll finally get free ! Our coder was not treating us well... removing elements from an array while running through it... I think he was a bit crazy ")
