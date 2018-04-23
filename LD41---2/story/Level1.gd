extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass


func _on_Debut_body_enter( body ):
	if body.get_name().match("player") :
		nc.post_notification("commamsg", ",   :  You can MOVE with ARROW LEFT and RIGHT and JUMP with ARROW UP")


func _on_Jump_body_enter( body ):	
	if body.get_name().match("player") :
		nc.post_notification("commamsg", ",   :  You should try to type \"JUMP\", then press ENTER and try to press the UP ARROW")


func _on_Dash_body_enter( body ):	
	if body.get_name().match("player") :
		nc.post_notification("commamsg", ",   :  You can DASH with Ctrl")


func _on_DashNoob_body_enter( body ):	
	if body.get_name().match("player") :
		nc.post_notification("commamsg", ",   :  Maybe type \"DASH\", then press ENTER and finnaly Ctrl ?")
