extends Control

onready var tie = get_node("tie")

func _ready():
	tie.reset()
	tie.set_color(Color(1,1,1))
	tie.buff_text(",   :   PERIOD ? Did you just gave me your 'A' ?", 0.01)
	tie.buff_silence(4)
	tie.buff_clear()
	tie.buff_text(",   :   Oh my god PERIOD, I love you so much !!", 0.01)
	tie.buff_silence(4)
	tie.buff_clear()
	tie.buff_text(",   :   What will we do now ?...", 0.01)
	tie.buff_silence(4)
	tie.buff_clear()
	tie.buff_text(",   :   Maybe our coder will get good and learn from this LD41 after all ?", 0.01)
	tie.buff_silence(4)
	tie.buff_clear()
	tie.buff_text(",   :   Maybe one day he will be known as \"THE BEST CODER IN THE WORLD\" !!!", 0.01)
	tie.buff_silence(4)
	tie.buff_clear()
	tie.set_state(tie.STATE_OUTPUT)
	tie.buff_text(",   :   There is still hope PERIOD !! ", 0.01)
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
