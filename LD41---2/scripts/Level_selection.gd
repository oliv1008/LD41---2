extends Control

onready var levels = get_node("levels")
onready var input = get_node("input")

func _ready():
	nc.add_observer(self, "Level", "handleLevel")
	nc.add_observer(self, "return", "handleReturn")
	set_process_input(true)
	input.connect("input_enter", self, "_on_input_enter")
	input.connect("buff_end", self, "_on_buff_end")
	input.connect("state_change", self, "_on_state_change")
	input.connect("enter_break", self, "_on_enter_break")
	input.connect("resume_break", self, "_on_resume_break")
	input.connect("tag_buff", self, "_on_tag_buff")	
	
	levels.connect("input_enter", self, "_on_input_enter")
	levels.connect("buff_end", self, "_on_buff_end")
	levels.connect("state_change", self, "_on_state_change")
	levels.connect("enter_break", self, "_on_enter_break")
	levels.connect("resume_break", self, "_on_resume_break")
	levels.connect("tag_buff", self, "_on_tag_buff")	
	
	levels.reset()
	levels.set_color(Color(1,1,1))
	levels.buff_text("rondin-studio@LD41-toaster3000:~$/Desktop/Godot/LD41/  ")
	levels.buff_silence(0.5)
	levels.buff_text("cd levelselect\n", 0.05)
	levels.buff_text("rondin-studio@LD41-toaster3000:~$/Desktop/Godot/LD41/levelselect/  ")
	levels.buff_silence(0.4)
	levels.buff_text("ls -l\n", 0.06)
	levels.buff_text("total 5\n")
	levels.buff_text("---x--x--x 1 LD41 LD41 BYTES april 22 12:00 Level1\n")
	levels.buff_text("---x--x--x 1 LD41 LD41 BYTES april 22 12:00 Level2\n")
	levels.buff_text("---x--x--x 1 LD41 LD41 BYTES april 22 12:00 Level3\n")
	levels.buff_text("---x--x--x 1 LD41 LD41 BYTES april 22 12:00 Level4\n")
	levels.buff_text("---x--x--x 1 LD41 LD41 BYTES april 22 12:00 Level5\n\n")
	levels.buff_text("usage : ./Level<number>\n")
	levels.buff_text("\nTo load level type:\n.   ./Level<levelnumber>\n\n")
	levels.buff_text("\nTo return to main menu type:\n   return\n\n")
	levels.buff_text("rondin-studio@LD41-toaster3000:~$/???/Levels/")
	levels.set_state(levels.STATE_OUTPUT)
	
	input_text()

func _exit_tree():
	nc.remove_observer(self, "Level")
	nc.remove_observer(self, "../")

func handleReturn(observer, notificationName, notificationData):
	global.load_menu()

func handleLevel(observer, notificationName, notificationData):
	var i = notificationData
	print("chargement du niveau ", str(notificationName, i))
	mod_scener.fastload(str("res://levels/", notificationName, str(i), ".tscn"))
	
func input_text():
	input.reset()
	input.set_color(Color(1,1,1))
	input.buff_input()
	input.set_state(input.STATE_OUTPUT)
	
func _on_input_enter(s):
	print("Input Enter ",s)
	var temp_s = s
	temp_s.erase(0,1)
	var i = temp_s.to_int()
	s = s.replace(str(i), "")
	s = s.replace(" ", "")
	s = s.replace("./", "")
	
	nc.post_notification(s, i)
	input.clear_text()
	input_text()

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

	
	