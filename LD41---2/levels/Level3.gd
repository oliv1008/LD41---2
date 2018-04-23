extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	

func _on_Debut1_body_enter( body ):
	if body.get_name().match("player") :
		nc.post_notification("commamsg", ",   :  You know PERIOD, I'm really happy that we are finally doing this together, this is the best day of my LIFE =D ")

func _on_Debut_body_enter( body ):
	if body.get_name().match("player") :
		nc.post_notification("commamsg", ",   :  TAB is the key for changing GRAVITY ;)  ")



func _on_Debut2_body_enter( body ):
	if body.get_name().match("player") :
		nc.post_notification("commamsg", ",   :  You need a bit a focus for this part, it's bit tricky, but I know you will make it PERIOD, I believe in you ! Good luck !")
