extends Control

onready var output = get_node("output")
onready var input = get_node("input")

var delegate = self

func _ready():
	nc.post_notification("PAUSE", null)
	
	nc.add_observer(self, "RESUME", "handleResume")
	nc.add_observer(self, "R", "handleRestart")
	nc.add_observer(self, "QUIT", "handleQuit")
	
	output.connect("input_enter", self, "_on_input_enter")
	output.connect("buff_end", self, "_on_buff_end")
	output.connect("state_change", self, "_on_state_change")
	output.connect("enter_break", self, "_on_enter_break")
	output.connect("resume_break", self, "_on_resume_break")
	output.connect("tag_buff", self, "_on_tag_buff")	

	input.connect("input_enter", self, "_on_input_enter")
	input.connect("buff_end", self, "_on_buff_end")
	input.connect("state_change", self, "_on_state_change")
	input.connect("enter_break", self, "_on_enter_break")
	input.connect("resume_break", self, "_on_resume_break")
	input.connect("tag_buff", self, "_on_tag_buff")	

	output.reset()
	output.set_color(Color(1,1,1))
	output.buff_text("rondin-studio@LD41-toaster3000:~/???/Pause$  ")
	output.buff_silence(0.3)
	output.buff_text("help\n", 0.07)
	output.buff_text("  usage : resume\n                 r(estart)\n                 quit (to main menu)")
	output.set_state(output.STATE_OUTPUT)
	
	input_text()
	set_process_input(true)
	
func _exit_tree():
	nc.remove_observer(self, "RESUME")
	nc.remove_observer(self, "R")
	nc.remove_observer(self, "QUIT")
	
func _input(event):
	get_tree().set_input_as_handled()
	if event.type == InputEvent.KEY and event.is_pressed() and event.is_action_pressed("ui_cancel"):
		nc.post_notification("RESUME", null)
	
func handleResume(observer, notificationName, notificationData):
	var response = {"message":"Continue"};
	if delegate.has_method("close_dialog"):
		delegate.close_dialog(self, response)
	
func handleRestart(observer, notificationName, notificationData):
	var response = {"message":"Restart"};
	if delegate.has_method("close_dialog"):
		delegate.close_dialog(self, response)
	
func handleQuit(observer, notificationName, notificationData):
	var response = {"message":"Quit"};
	if delegate.has_method("close_dialog"):
		delegate.close_dialog(self, response)
	
func input_text():
	input.reset()
	input.set_color(Color(1,1,1))
		# Schedule an Input in the buffer, after all
		# the text before it is displayed
	input.buff_input()
	input.set_state(input.STATE_OUTPUT)
	
func _on_input_enter(s):
	print("Input Enter ",s)
	s = s.to_upper()
	s = s.replace(" ", "")
	if s.match("RESUME") or s.match("QUIT") or s.match("R"):
		nc.post_notification(s, null)
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