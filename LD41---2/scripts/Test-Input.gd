extends Node2D

onready var tie = get_node("Panel/TextInterfaceEngine")
var focus = false
var panel_rect

func _ready():
	# Connect every signal to check them using the "print()" method
	tie.connect("input_enter", self, "_on_input_enter")
	tie.connect("buff_end", self, "_on_buff_end")
	tie.connect("state_change", self, "_on_state_change")
	tie.connect("enter_break", self, "_on_enter_break")
	tie.connect("resume_break", self, "_on_resume_break")
	tie.connect("tag_buff", self, "_on_tag_buff")	
	
	set_process_input(true)
	set_fixed_process(true)
	
	panel_rect = get_node("Panel").get_rect()
	
func _fixed_process(delta):
#	print("focus = ", focus)
	pass
	
func _input(event):
#   # Mouse in viewport coordinates
	if (event.type==InputEvent.MOUSE_BUTTON and event.is_pressed() and event.button_index == BUTTON_LEFT):
		var mouse_pos = event.pos
		if panel_rect.has_point(mouse_pos):
			focus = true
		else:
			focus = false
		if focus == true:
			input_text()
	
func input_text():
	tie.reset()
	tie.set_color(Color(0.3,1,1))
		# Schedule an Input in the buffer, after all
		# the text before it is displayed
	tie.buff_text("Hey there!! What's your name?\n", 0.01)
	tie.buff_input()
	tie.set_state(tie.STATE_OUTPUT)
	
func _on_input_enter(s):
	print("Input Enter ",s)
	
	tie.add_newline()
	tie.buff_text("Oooh, so your name is " + s + "? What a beautiful name!", 0.01)
	pass
	
func _on_buff_end():
	print("Buff End")
	pass

func _on_state_change(i):
	print("New state: ", i)
	pass

func _on_enter_break():
	print("Enter Break")
	pass

func _on_resume_break():
	print("Resume Break")
	pass

func _on_tag_buff(s):
	print("Tag Buff ",s)
	pass
