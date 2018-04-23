extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_Fail_body_enter( body ):
	if body.get_name().match("player") :
		nc.post_notification("commamsg", ",   :  You can acces to the pause menu with ESC")

func _on_WallJump_body_enter( body ):
	if body.get_name().match("player") :
		nc.post_notification("commamsg", ",   :  You need to unlock the WALL JUMP ability to pass this obstacle and you are also needing 2 JUMP, you know what to do ! (JUMP2 and WALLJUMP)")

func _on_Debut_body_enter( body ):
	if body.get_name().match("player") :
		nc.post_notification("commamsg", ",   :  You can see all your available letters on the top left corner of the screen.")


func _on_double_body_enter( body ):
	if body.get_name().match("player") :
		nc.post_notification("commamsg", ",   :  Maybe you should try to unlock the DOUBLE JUMP ability or the DOUBLE DASH ability ?")
