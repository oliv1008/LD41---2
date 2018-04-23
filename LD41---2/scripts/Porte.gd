extends Node2D

export (String) var lettre
var is_player_near = false
var initial_pos = Vector2()
var porte_rec
var player

var MAX_OPENING_SPEED = 100
var OPENING_ACCELERATION = 20
var speed = Vector2()
var velocity = Vector2()

onready var label = get_node("CenterContainer/Label")
onready var porte = get_node("StaticBody2D/Porte")

func _ready():
	initial_pos = get_pos()
	porte_rec = porte.get_polygon()
	print("porte_rec = ", porte_rec)
	lettre = lettre.to_upper()
	nc.add_observer(self, lettre, "handleOpen")
	label.set_text(lettre)

func _fixed_process(delta):
	speed.y += OPENING_ACCELERATION * delta
	if speed.y >= MAX_OPENING_SPEED:
		speed.y = MAX_OPENING_SPEED
		
	velocity = Vector2(0, speed.y * delta)
	set_pos(get_pos() + velocity)
	print("get_pos() = ", get_pos())
	print("initial_pos.y + (porte_rec[1].y - porte_rec[0].y) = ", initial_pos.y + (porte_rec[1].y - porte_rec[0].y))
	if get_pos().y > initial_pos.y + (porte_rec[1].y - porte_rec[0].y):
		set_fixed_process(false)

func _on_ZoneInteraction_body_enter( body ):
	if body.get_name().match("player"):
		player = body
		print("Le joueur est assez proche pour ouvrir la porte !")
		is_player_near = true

func _on_ZoneInteraction_body_exit( body ):
	if body.get_name().match("player"):
		player = null
		print("Le joueur n'est pas plus assez proche pour ouvrir la porte ...")
		is_player_near = false

func handleOpen(observer, notificationName, notificationData):
	if is_player_near:
		set_fixed_process(true)
		player.clearAlphabet(notificationName)
		nc.post_notification("letters_of_player_modified", null)

