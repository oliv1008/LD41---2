extends Control

onready var tieInput
onready var tieOutput
var dot = RigidBody2D
onready var sound

var isPlayerTyping = false

func _ready():
	dot = RigidBody2D.new()
	var polygon = Polygon2D.new()
	var polygon_rect = [Vector2(0,0), Vector2(6,0), Vector2(6,6), Vector2(0,6)]
	polygon.set_polygon(Vector2Array(polygon_rect))
	polygon.set_color(Color(1,1,1))
	dot.add_child(polygon)
	dot.set_pos(Vector2(995, -100))
	dot.set_gravity_scale(1)
	add_child(dot)
	set_fixed_process(true)

	tieInput = get_node("TextInterfaceEngine")
	tieOutput = get_node("Text")
	sound = get_node("SamplePlayer2D")
	tieInput.set_hidden(true)
	
	nc.add_observer(self, "EXIT", "menuQuit")
	nc.add_observer(self, "CDLEVELSELECT", "menuLevelSelect")
	nc.add_observer(self, "MVPERIOD./DESKTOP/GODOT/", "menuNewGame")
	nc.add_observer(self, "MVPERIOD../", "menuNewGame")
	nc.add_observer(self, "MVPERIOD./DESKTOP/", "menuNiceTry")
	nc.add_observer(self, "MVPERIOD./", "menuNiceTry")
	nc.add_observer(self, "MVPERIOD../../", "menuNiceTry")
	
	tieInput.connect("input_enter", self, "_on_input_enter")
	tieInput.connect("buff_end", self, "_on_buff_end")
	tieInput.connect("state_change", self, "_on_state_change")
	tieInput.connect("enter_break", self, "_on_enter_break")
	tieInput.connect("resume_break", self, "_on_resume_break")
	tieInput.connect("tag_buff", self, "_on_tag_buff")
	
	tieOutput.connect("input_enter", self, "_on_input_enter")
	tieOutput.connect("buff_end", self, "_on_buff_end")
	tieOutput.connect("state_change", self, "_on_state_change")
	tieOutput.connect("enter_break", self, "_on_enter_break")
	tieOutput.connect("resume_break", self, "_on_resume_break")
	tieOutput.connect("tag_buff", self, "_on_tag_buff")	
	
	set_process_input(true)
	
	#var usage = "\n   usage:   period   [-menu <option>]\n\n   <option> availables :\n      level select\n      quit \n\n\n   To escape (begin game) you should try to move period outside the folder\n\n   usage:   mv   <source>   <destination>\n\n   <source> availables :\n      ./period\n\n   <destination> availables :\n      ./Desktop/Godot/\n      ../\n\nrondin-studio@LD41-toaster3000:~$/Desktop/Godot/LD41/"
	var usage = "\n   to begin the game type :\n      mv period ../\n\n   to go to level selection type:\n      cd levelselect\n\n   to quit the game type:\n      exit\n\nrondin-studio@LD41-toaster3000:~$/Desktop/Godot/LD41/  "      
	tieOutput.reset()
	tieOutput.set_color(Color(1,1,1))
	tieOutput.set_turbomode(false)
	tieOutput.buff_text("rondin-studio@LD41-toaster3000:~$/Desktop/Godot/LD41/  ", 0.01)
	tieOutput.buff_silence(0.5)
	tieOutput.set_turbomode(false)
	tieOutput.setUserIsTyping(true)
	tieOutput.buff_text("/period\n", 0.05)
	isPlayerTyping = false
	tieOutput.buff_silence(0.5)
	tieOutput.set_turbomode(false)
	tieOutput.buff_text(usage, 0.005)
	tieOutput.set_state(tieOutput.STATE_OUTPUT)
	
	input_text()
	pass
	
func _exit_tree():
	nc.remove_observer(self, "EXIT")
	nc.remove_observer(self, "CDLEVELSELECT")
	nc.remove_observer(self, "MVPERIOD./DESKTOP/GODOT/")
	nc.remove_observer(self, "MVPERIOD../")
	nc.remove_observer(self, "MVPERIOD./DESKTOP/")
	nc.remove_observer(self, "MVPERIOD./")
	nc.remove_observer(self, "MVPERIOD../../")

func menuQuit(observer, notificationName, notificationData):
	print("QUIT")
	get_tree().quit()

func menuLevelSelect(observer, notificationName, notificationData):
	global.to_next_level("res://levels/Level_selection.tscn")
	print("LEVEL SELECT")
	
func menuNewGame(observer, notificationName, notificationData):
	print("ESCAPE")
	global.to_next_level("res://levels/Level1.tscn")

func menuNiceTry(observer, notificationName, notificationData):
	print("NICE TRY")
	tieOutput.buff_text("\n NICE TRY BUT YOU CAN'T", 0.01)
	tieOutput.set_state(tieOutput.STATE_OUTPUT)
	
func handleFadeInOver(observer, notificationName, notificationData):
	dot = RigidBody2D.new()
	var polygon = Polygon2D.new()
	var polygon_rect = [Vector2(0,0), Vector2(6,0), Vector2(6,6), Vector2(0,6)]
	polygon.set_polygon(Vector2Array(polygon_rect))
	polygon.set_color(Color(1,1,1))
	dot.add_child(polygon)
	dot.set_pos(Vector2(995, -100))
	dot.set_gravity_scale(1)
	add_child(dot)
	set_fixed_process(true)

func _fixed_process(delta):
	if dot.get_pos().y >= 142:
		print("ici")
		dot.set_gravity_scale(0)
		dot.set_sleeping(true)
		dot.set_pos(Vector2(995, 142))
		set_fixed_process(false)

func _input(event):
	if event.type == InputEvent.KEY && event.is_pressed() && event.ID != KEY_UP && event.ID != KEY_DOWN && event.ID != KEY_LEFT && event.ID != KEY_RIGHT:
		sound.play(str("clavier_", randi() % 7 + 1))
		
	if event.is_action_pressed("ui_cancel") and event.is_pressed():
		input_text()
		tieOutput.set_turbomode(true)
	if event.type == InputEvent.MOUSE_BUTTON and event.is_pressed() and event.button_index == BUTTON_LEFT:
		print("mouse_pos = ", event.pos)
	if event.type == InputEvent.MOUSE_BUTTON and event.is_pressed() and event.button_index == BUTTON_RIGHT:
		nc.post_notification("fade_in_over", null)
		
func input_text():
	tieInput.reset()
	tieInput.set_color(Color(1,1,1))
		# Schedule an Input in the buffer, after all
		# the text before it is displayed
	tieInput.buff_input()
	tieInput.set_state(tieInput.STATE_OUTPUT)
	
func _on_input_enter(s):
	print("Input Enter ",s)
	s = s.to_upper()
	s = s.replace(" ", "")
	nc.post_notification(s, null)
	tieInput.clear_text()
	input_text()

func _on_buff_end():
	print("Buff End")	
	tieInput.set_hidden(false)
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

