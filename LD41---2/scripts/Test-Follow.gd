extends Node2D

onready var TweenNode1 = get_node("Tween1")
onready var TweenNode2 = get_node("Tween2")
onready var child = get_node("Child") 
onready var papa = get_node("Papa")

func _ready():
	set_process(true)
	
func _process(delta):
	var mouse_pos = get_global_mouse_pos()
	var isMoving = false
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		TweenNode1.interpolate_property(papa, "transform/pos", papa.get_pos(), mouse_pos, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		TweenNode1.start()
		isMoving = true
	
	var time
	if isMoving : time = 0
	else : time = 1
	
	if isMoving :
		TweenNode2.follow_property(child, "transform/pos", child.get_pos(), papa, "transform/pos", 3, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		TweenNode2.start()
	pass
