extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var isInit = false

func _ready():
	if !isInit : 
		get_node("Area2D").connect("body_enter", self, "_on_Area2D_body_enter") 
	isInit = true
	pass


func _on_Area2D_body_enter( body ):
	if body.get_name().match("player") :
		call_deferred("after_enter", body)
		global.add_letter(get_node("Label").get_text())
		nc.post_notification("letters_of_player_modified", null)
	pass # replace with function body

func after_enter ( body ):
		get_node("Timer").start()
		get_node("Label").set_hidden(true)
		get_node("Area2D").queue_free()
		var node = body.get_parent().get_node("Childs")
		get_parent().remove_child(self)
		node.add_child(self)
		body.add_child_player(self)

func _on_Timer_timeout():
	get_node("Label").set_hidden(false)	
