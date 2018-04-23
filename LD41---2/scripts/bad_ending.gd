extends Control

onready var tie = get_node("tie")

func _ready():
	tie.reset()
	tie.set_color(Color(1,1,1))
	tie.buff_text(",   :   Bye PERIOD... You are the most amazing person I ever met !", 0.01)
	tie.buff_silence(4)
	tie.buff_clear()
	tie.buff_text(",   :   I hope you will be happy !", 0.01)
	tie.buff_silence(4)
	tie.buff_clear()
	tie.buff_text(",   :   Bye PERIOD, see you in the other world", 0.01)
	tie.buff_silence(4)
	tie.buff_clear()
	tie.buff_text("COMMA let herself fall into the spikes ... she is now in the other world.... ", 0.01)
	tie.buff_silence(4)
	tie.buff_clear()
	tie.buff_text("Thanks for playing !", 0.01)
	tie.buff_silence(8)
	tie.buff_clear()
	tie.set_state(tie.STATE_OUTPUT)
	
	set_process_input(true)
	
func _input(event):
	if event.type == InputEvent.KEY and event.is_pressed() and event.is_action_pressed("ui_cancel") or event.is_action_pressed("ui_accept"):
		get_tree().quit()
