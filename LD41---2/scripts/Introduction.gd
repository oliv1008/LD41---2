extends Control

onready var commandes = get_node("commandes")
onready var dialogue = get_node("dialogue_coma")
var dot = RigidBody2D.new()
var dot_pos = Vector2(972, 117)
var dialogue_coma_begun = false

func _ready():
	commandes.connect("input_enter", self, "_on_input_enter")
	commandes.connect("buff_end", self, "_on_buff_end")
	commandes.connect("state_change", self, "_on_state_change")
	commandes.connect("enter_break", self, "_on_enter_break")
	commandes.connect("resume_break", self, "_on_resume_break")
	commandes.connect("tag_buff", self, "_on_tag_buff")	
	
	dialogue.connect("input_enter", self, "_on_input_enter")
	dialogue.connect("buff_end", self, "_on_buff_end")
	dialogue.connect("state_change", self, "_on_state_change")
	dialogue.connect("enter_break", self, "_on_enter_break")
	dialogue.connect("resume_break", self, "_on_resume_break")
	dialogue.connect("tag_buff", self, "_on_tag_buff")	
	
	set_fixed_process(true)
	commandes.reset()
	commandes.set_color(Color(1,1,1))
	commandes.buff_text("rondin-studio@LD41-toaster3000:~$ ")
	commandes.buff_silence(1)
	commandes.buff_text("cd Desktop/Godot/LD41\n", 0.01)
	commandes.buff_silence(0.4)
	commandes.buff_text("rondin-studio@LD41-toaster3000:~/Desktop/Godot/LD41$ ")
	commandes.buff_silence(1)
	commandes.buff_text("git pull\n", 0.01)
	commandes.buff_silence(0.5)
	commandes.buff_text("Already up-to date\n")
	commandes.buff_text("rondin-studio@LD41-toaster3000:~/Desktop/Godot/LD41$ ")
	commandes.buff_silence(0.4)
	commandes.buff_text(" /Godot_v2.1.4-stable_x11.64", 0.01, " ")
	commandes.buff_silence(2)
	commandes.set_state(commandes.STATE_OUTPUT)
	
	set_process_input(true)
	
func _input(event):
	if (event.type==InputEvent.MOUSE_BUTTON and event.is_pressed() and event.button_index == BUTTON_LEFT):
		print("event_pos = ", event.pos)
		pass
	if event.is_action_pressed("ui_cancel") and event.is_pressed():
		global.load_menu()
		
func _fixed_process(delta):
	var window_size = get_viewport().get_rect().size
	if dot.get_pos().y > window_size.y:
		global.load_menu()
		
func _on_buff_end():
	print("Buff End")
	if dialogue_coma_begun == false:
		dialogue_with_coma()
	else:
		dot.set_gravity_scale(2)
		set_fixed_process(true)

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
	if s.match(" "):
		instantiate_dot()
	pass

func instantiate_dot():
	var polygon = Polygon2D.new()
	var polygon_rect = [Vector2(0, 0), Vector2(6, 0), Vector2(6, 6), Vector2(0, 6)]
	polygon.set_polygon(Vector2Array(polygon_rect))
	polygon.set_color(Color(1,1,1))
	dot.add_child(polygon)
	dot.set_gravity_scale(0)
	dot.set_pos(dot_pos)
	add_child(dot)

func dialogue_with_coma():
	dialogue_coma_begun = true
	dialogue.reset()
	dialogue.set_color(Color(1,1,1))
	dialogue.buff_text(",   :  Hey PERIOD ! It's me COMMA ! What's up ?\n", 0.01)
	dialogue.buff_break()
	dialogue.buff_clear()
	dialogue.buff_text(",  :  Today is the day ! We are finally leaving our poor coder !\n", 0.01)
	dialogue.buff_break()
	dialogue.buff_clear()
	dialogue.buff_text(",  :  We will finally be free from this noob !\n", 0.01)
	dialogue.buff_break()
	dialogue.buff_clear()
	dialogue.buff_text(",  :  Seriously this guy is a nightmare, a game jam of 48h doesn't mean you have to code in such a poor way\n", 0.01)
	dialogue.buff_break()
	dialogue.buff_clear()
	dialogue.buff_text(",  :  Today is our one and only chance to have a new coder !\n", 0.01)
	dialogue.buff_break()
	dialogue.buff_clear()
	dialogue.buff_text(",  :  I'm sure he is very organised, and he probably now how to write clean code and proper variable names\n" , 0.01)
	dialogue.buff_break()
	dialogue.buff_clear()
	dialogue.buff_text(",  :  So, the first step is to go out of the LD41 folder, just let you fall down. See you !", 0.01)
	dialogue.buff_break()
	dialogue.buff_clear()
	dialogue.set_state(dialogue.STATE_OUTPUT)
	
func skip_intro():
	pass