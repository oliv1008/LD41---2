extends Control

onready var tie_alphabet = get_node("MarginContainer/Alphabet")
onready var tie = get_node("CenterContainer/TextInterfaceEngine")
onready var abilities = get_node("MarginContainer_abilities/abilities")
onready var quantity = get_node("MarginContainer_quantity/quantity")
onready var variables_right = get_node("MarginContainer_right/variables_right")
onready var variables_left = get_node("MarginContainer_left/variables_left")
onready var comma = get_node("CenterCOMA/COMA")

onready var pause_dialogue_ressource = preload ("res://scenes/Pause.tscn")

var panel_rect
var focus = false
var is_abilities_empty = true
var is_quantity_empty = true

var player_variables_quantities = {
	"total_jump_count":0,
	"total_dash_count":0,
	"total_gravity_count":0
};

var player_variables_ability = {
	"MAX_JUMP_COUNT":0,
	"MAX_DASH_COUNT":0,
	"canWallJump" : false
};

func _ready():
	nc.add_observer(self, "letters_of_player_modified", "write_letters_of_player")
	nc.add_observer(self, "variables_modified", "handleVariableModified")
	nc.add_observer(self, "commamsg", "comma_msg")

	# Connect every signal to check them using the "print()" method
	comma.connect("input_enter", self, "_on_input_enter")
	comma.connect("buff_end", self, "_on_buff_end")
	comma.connect("state_change", self, "_on_state_change")
	comma.connect("enter_break", self, "_on_enter_break")
	comma.connect("resume_break", self, "_on_resume_break")
	comma.connect("tag_buff", self, "_on_tag_buff")

	tie.connect("input_enter", self, "_on_input_enter")
	tie.connect("buff_end", self, "_on_buff_end")
	tie.connect("state_change", self, "_on_state_change")
	tie.connect("enter_break", self, "_on_enter_break")
	tie.connect("resume_break", self, "_on_resume_break")
	tie.connect("tag_buff", self, "_on_tag_buff")	
	
	tie_alphabet.connect("input_enter", self, "_on_input_enter")
	tie_alphabet.connect("buff_end", self, "_on_buff_end")
	tie_alphabet.connect("state_change", self, "_on_state_change")
	tie_alphabet.connect("enter_break", self, "_on_enter_break")
	tie_alphabet.connect("resume_break", self, "_on_resume_break")
	tie_alphabet.connect("tag_buff", self, "_on_tag_buff")	

	variables_left.connect("input_enter", self, "_on_input_enter")
	variables_left.connect("buff_end", self, "_on_buff_end")
	variables_left.connect("state_change", self, "_on_state_change")
	variables_left.connect("enter_break", self, "_on_enter_break")
	variables_left.connect("resume_break", self, "_on_resume_break")
	variables_left.connect("tag_buff", self, "_on_tag_buff")	

	variables_right.connect("input_enter", self, "_on_input_enter")
	variables_right.connect("buff_end", self, "_on_buff_end")
	variables_right.connect("state_change", self, "_on_state_change")
	variables_right.connect("enter_break", self, "_on_enter_break")
	variables_right.connect("resume_break", self, "_on_resume_break")
	variables_right.connect("tag_buff", self, "_on_tag_buff")	
	
	tie_alphabet.reset()
	tie_alphabet.set_color(Color(0.5,0.5,0.5))
	tie_alphabet.buff_text(global.letters_of_player, 0.05)
	tie_alphabet.set_state(tie_alphabet.STATE_OUTPUT)
	
	input_text()
	
	set_process_input(true)

func _input(event):
	if event.type == InputEvent.KEY && event.is_pressed() && !event.is_action("exception"):
		nc.post_notification("clavier", null)
		print("CLAVIER")
	if event.is_action_pressed("ui_cancel") and event.is_pressed():
		if tie.get_text().empty():
			show_pause_dialog()
		else:
			input_text()

func input_text():
	tie.reset()
	tie.set_color(Color(0.5,0.5,0.5))
		# Schedule an Input in the buffer, after all
		# the text before it is displayed
	tie.buff_input()
	tie.set_state(tie.STATE_OUTPUT)
	
func _on_input_enter(s):
	print("Input Enter ",s)
	s = s.to_upper()
	var i = s.to_int()
	if s.find(str(i)) != -1 : s = s.replace(str(i), "")
	else : i = null
	s = s.replace(" ", "")
	if global.check_input(s):
		print("Input valide, on envoie la notif")
		nc.post_notification(s, i)
	else:
		print("Input, invalide")
		nc.post_notification("rejected", null)
	tie.clear_text()
	input_text()


func comma_msg(observer, notificationName, notificationData):
	comma.reset()
	comma.set_color(Color(0.5,0.5,0.5))
	comma.buff_text(notificationData, 0.01)
	comma.buff_silence(5)
	comma.buff_clear()
	comma.set_state(comma.STATE_OUTPUT)
	
func write_letters_of_player(observer, notificationName, notificationData):
	print("on réecris les lettres")
	global.reorganize_letters()
	tie_alphabet.reset()
	tie_alphabet.set_color(Color(0.5,0.5,0.5))
	tie_alphabet.buff_text(global.letters_of_player)
	tie_alphabet.set_state(tie_alphabet.STATE_OUTPUT)
	
func handleVariableModified(observer, notificationName, notificationData):
	if notificationData.type.match("abilities"):
		player_variables_ability[notificationData["name"]] = notificationData.number
		is_abilities_empty = false
	else:
		player_variables_quantities[notificationData["name"]] = notificationData.number
		var array = player_variables_quantities.values()
		print("array = ", array)
		is_quantity_empty = true
		for i in array:
			if i != 0:
				is_quantity_empty = false
	organizeVariables()
	
func organizeVariables():
	quantity.reset()
	abilities.reset()
	variables_left.reset()
	variables_right.reset()
	
	if is_quantity_empty:
		quantity.reset()
		variables_right.reset()
	else:
		quantity.set_color(Color(0.5,0.5,0.5))
		variables_left.set_color(Color(0.5,0.5,0.5))
		quantity.buff_text("Quantities")
		print("player_variables_left = ", player_variables_quantities["total_gravity_count"])
		if player_variables_quantities.total_jump_count != 0:
			variables_left.buff_text(str("int number_of_jump = ", str(player_variables_quantities.total_jump_count), "\n"))
		if player_variables_quantities.total_dash_count != 0:
			variables_left.buff_text(str("int number_of_dash = ", str(player_variables_quantities.total_dash_count), "\n"))
		if player_variables_quantities.total_gravity_count != 0:
			variables_left.buff_text(str("int number_of_gravity_change = ", str(player_variables_quantities.total_gravity_count), "\n"))
		quantity.set_state(quantity.STATE_OUTPUT)
		variables_left.set_state(variables_left.STATE_OUTPUT)
		
	if is_abilities_empty:
		abilities.reset()
		variables_right.reset()
	else:
		abilities.set_color(Color(0.5,0.5,0.5))
		variables_right.set_color(Color(0.5,0.5,0.5))
		abilities.buff_text("Abilities")
		if player_variables_ability.canWallJump == true:
			variables_right.buff_text("bool can_wall_jump = true\n")
		if player_variables_ability.MAX_JUMP_COUNT == 2:
			variables_right.buff_text("bool can_double_jump = true\n")
		elif player_variables_ability.MAX_JUMP_COUNT == 3:
			variables_right.buff_text("bool can_triple_jump = true\n")
		if player_variables_ability.MAX_DASH_COUNT == 2:
			variables_right.buff_text("bool can_double_dash = true\n")
		elif player_variables_ability.MAX_DASH_COUNT == 3:
			variables_right.buff_text("bool can_triple_dash = true\n")
		abilities.set_state(abilities.STATE_OUTPUT)
		variables_right.set_state(variables_right.STATE_OUTPUT)
		
func show_pause_dialog():
	var pauseDialogNode = pause_dialogue_ressource.instance()
	self.add_child(pauseDialogNode)
	pauseDialogNode.delegate = self 
	tie.reset()
		
#delegate functions
func close_dialog(dialog, response):
	input_text()
	dialog.queue_free() # close the dialog
	set_process_input(true)
	if(response.message == "Continue"):
		pass
	elif(response.message == "Restart"):
		global.clear_singleton()
		get_tree().reload_current_scene()
	else:
		global.load_menu() # abandon
		
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
