extends Node2D

onready var final_dialogue = get_node("final_dialogue")

func _ready():
	nc.add_observer(self, "GIVEA", "handleGiveA")
	
	final_dialogue.reset()
	final_dialogue.set_color(Color(1,1,1))
	final_dialogue.buff_text("PERIOD ! You're finally here !", 0.01)
	final_dialogue.buff_silence(5)
	final_dialogue.buff_clear()
	final_dialogue.buff_text("I'm so happy to see you <3", 0.01)
	final_dialogue.buff_silence(4)
	final_dialogue.buff_clear()
	final_dialogue.buff_text("But I'm so sad too...", 0.01)
	final_dialogue.buff_silence(4)
	final_dialogue.buff_clear()
	final_dialogue.buff_text("I have 'D', 'S', 'H', I just need a 'A' to DASH and join you", 0.01)
	final_dialogue.buff_silence(5)
	final_dialogue.buff_clear()
	final_dialogue.buff_text("But if you give me your 'A', you can't escape and free yourself from here...", 0.01)
	final_dialogue.buff_silence(5)
	final_dialogue.buff_clear()
	final_dialogue.buff_text("And we are lock in this place together forever...", 0.01)
	final_dialogue.buff_silence(3)
	final_dialogue.buff_clear()
	final_dialogue.buff_text("You should just go and live your own life without me, this place is a nightmare, I'll be happy for you if you leave", 0.01)
	final_dialogue.buff_silence(6)
	final_dialogue.buff_clear()
	final_dialogue.buff_text("I love you PERIOD", 0.01)
	final_dialogue.buff_silence(6)
	final_dialogue.buff_clear()
	final_dialogue.set_state(final_dialogue.STATE_OUTPUT)
	
func handleGiveA(observer, notificationName, notificationData):
	clearAlphabet(notificationName)
	mod_scener.fastload("res://levels/good_ending.tscn")

func clearAlphabet(letters_to_delete):
	var indice
	for i in letters_to_delete:
		indice = global.letters_of_player.find(i)
		global.remove(indice, 1)
	nc.post_notification("letters_of_player_modified", null)
	pass

func _on_Area2D_body_enter( body ):
	if body.get_name().match("player"):
		global.add_letter("ESCAPE OR GIVE")
		nc.post_notification("letters_of_player_modified", null)
