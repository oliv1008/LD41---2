extends KinematicBody2D

var input_direction = 0
var direction = 1

var speed = Vector2()
var velocity = Vector2()

export (int) var MAX_SPEED = 700
export (int) var ACCELERATION = 2600
export (int) var DECELERATION = 5000

export (int) var WALL_JUMP_FORCE_HORIZONTALE = 1000
export (int) var WALL_JUMP_FORCE_VERTICALE = 1000
export (int) var DASH_FORCE_HORIZONTALE = 3000
export (int) var JUMP_FORCE = 800
export (int) var GRAVITY = 2800
export (int) var MAX_FALL_SPEED = 1400

var jump_count = 0
var total_jump_count = 0
export (int) var MAX_JUMP_COUNT = 1
var dash_count = 0
var total_dash_count = 0
export (int) var MAX_DASH_COUNT = 1
var total_gravity_count = 0
var gravityModifier = 1
var canWallJump = true

var is_on_wall = false
var direction_wall_jump = 0
var slide_vector = Vector2()
var MAX_WALKABLE_SLOPE_ANGLE = 45
var SLIDE_CANCEL_TRESHOLD = 1.0

var childs = []
var positions_queues = []
var canFollow = []
var initChildCount = 0
var stepsUntilFollow = 3

var is_dying = false

var disableMoveRight = false
var disableMoveLeft = false
var disableMoveStepCount = 0
const disableMoveStepMax = 10

var isDashing = false
var dashStepCount = 0
const dashStepMax = 5
var dashTimer

var sound
func _ready():
	set_name("player")
	nc.add_observer(self, "PAUSE", "handlePause")
	nc.add_observer(self, "RESUME", "handleResume")
	sound = get_node("SamplePlayer2D")
	nc.add_observer(self, "JUMP", "handleJumpInput")
	nc.add_observer(self, "DASH", "addDash")
	nc.add_observer(self, "DOUBLEJUMP", "enableDoubleJump")
	nc.add_observer(self, "TRIPLEJUMP", "enableTripleJump")
	nc.add_observer(self, "DOUBLEDASH", "enableDoubleDash")
	nc.add_observer(self, "TRIPLEDASH", "enableTripleDash")
	nc.add_observer(self, "GRAVITY", "addGravity")
	nc.add_observer(self, "clavier", "keysound")
	nc.add_observer(self, "REJECTED", "rejectedsound")
	nc.add_observer(self, "WALLJUMP", "enableWallJump")
	
	set_fixed_process(true)
	set_process_input(true)
	childs = get_parent().get_node("Childs").get_children()
	var i = 0
	for j in childs :
		j.set_pos(get_pos())
		canFollow.append(false)
		positions_queues.append([])
		for k in range(stepsUntilFollow) :
			positions_queues[i].append(get_pos())
		i += 1
	canFollow.append(false)
	positions_queues.append([])
	for k in range(stepsUntilFollow * 2) :
		positions_queues[positions_queues.size() - 1].append(get_pos())
	dashTimer = get_node("DashTimer")
	var test = "toto12"
	var testint = test.to_int()

func add_child_player(letterNode) :
	sound.play("coin")
	canFollow.append(false)
	childs.append(letterNode)
	positions_queues.append([])
	for k in range(stepsUntilFollow) :
		positions_queues[positions_queues.size() - 1].append(get_pos())

func _input(event):
	if dash_count < MAX_DASH_COUNT and total_dash_count > 0 and event.is_action_pressed("dash") && ((input_direction == 1 && !disableMoveRight) || (input_direction == -1 && !disableMoveLeft)):
		isDashing = true
		sound.play("dash")
		dashTimer.start()
		dash_count += 1
		total_dash_count -= 1
		var notificationData = {
			"type" : "quantities",
			"name" : "total_dash_count",
			"number" : total_dash_count
		};
		nc.post_notification("variables_modified", notificationData)
		# dashStepCount = 0
	if total_gravity_count > 0 and event.is_action_pressed("gravity") :
		total_gravity_count -= 1
		var notificationData = {
			"type" : "quantities",
			"name" : "total_gravity_count",
			"number" : total_gravity_count
		};
		nc.post_notification("variables_modified", notificationData)
		gravityModifier = -gravityModifier
		speed.y = 0
	#TENTATIVE WALL JUMP
	if jump_count < MAX_JUMP_COUNT and total_jump_count > 0 and event.is_action_pressed("jump"):
		sound.play("jump")
		total_jump_count -= 1
		var notificationData = {
			"type" : "quantities",
			"name" : "total_jump_count",
			"number" : total_jump_count
		};
		nc.post_notification("variables_modified", notificationData)
		if is_on_wall:
			speed.y = -WALL_JUMP_FORCE_VERTICALE
			speed.x = WALL_JUMP_FORCE_HORIZONTALE
			direction = direction_wall_jump
			if direction == -1:
				disableMoveRight = true
				disableMoveStepCount = 0
			elif direction == 1:
				disableMoveLeft = true
				disableMoveStepCount = 0
			jump_count += 1
	#TENTATIVE WALL JUMP
		else:
			speed.y = -JUMP_FORCE
			jump_count += 1

func _fixed_process(delta):
	if disableMoveRight || disableMoveLeft:
		disableMoveStepCount += 1
	if disableMoveStepCount > disableMoveStepMax:
		disableMoveLeft = false
		disableMoveRight = false
	# if isDashing:
	#	dashStepCount += 1
	#if dashStepCount > dashStepMax :
	#	isDashing = false
	var posTemp = get_pos()
	var stop = true
	#print(posTemp)
	#print(positions_queues)
	#print(childs)
	if posTemp.x > (positions_queues[0][positions_queues[0].size() - 1].x + 1) || posTemp.x < (positions_queues[0][positions_queues[0].size() - 1].x  - 1) \
	|| posTemp.y > (positions_queues[0][positions_queues[0].size() - 1].y + 1) || posTemp.y < (positions_queues[0][positions_queues[0].size() - 1].y  - 1):
		positions_queues[0].append(posTemp)
		stop = false
	
	#if initChildCount < childs.size() :
	#	var distance = posTemp.distance_to(childs[initChildCount].get_pos())
	#	if distance > distanceUntilFollow * (initChildCount + 1) :
	#		canFollow[initChildCount] = true
	#		initChildCount += 1

	var i = 0
	for child in childs :
		if !stop :
			child.set_pos(positions_queues[i][0])
			positions_queues[i+1].append(positions_queues[i][0])
			positions_queues[i].remove(0)
		i += 1
	if !stop : positions_queues[i].remove(0)
	
	#var i = 0
	#for child in childs:
	#	if positions_queues[i].size() != 0 && canFollow[i] && !stop:
	#		child.set_pos(positions_queues[i][0])
	#		#if i < positions_queues.size() - 1:
	#		positions_queues[i+1].append(positions_queues[i][0])
	#		positions_queues[i].remove(0)
	#		# print(child.get_pos())
	#	i += 1
	
	if input_direction:
		if input_direction == 1 && !disableMoveRight || input_direction == -1 && !disableMoveLeft :
			direction = input_direction
	
	if Input.is_action_pressed("move_left") && !disableMoveLeft:
		input_direction = -1
	elif Input.is_action_pressed("move_right") && !disableMoveRight:
		input_direction = 1
	else:
		input_direction = 0
	
#	if not(is_on_wall):
#		if input_direction == - direction:
#			speed.x /= 3
#		if input_direction:
#			speed.x += ACCELERATION * delta
#		else:
#			speed.x -= DECELERATION * delta
#		speed.x = clamp(speed.x, 0, MAX_SPEED)
		
	if input_direction == - direction:
		speed.x /= 3
	if input_direction != direction_wall_jump || input_direction:
		speed.x += ACCELERATION * delta
	if input_direction == 0:
		speed.x -= DECELERATION * delta
	speed.x = clamp(speed.x, 0, MAX_SPEED)
	
	speed.y += GRAVITY * delta
	if abs(speed.y) > MAX_FALL_SPEED:
		speed.y = MAX_FALL_SPEED
	
	if isDashing :
		speed.x = DASH_FORCE_HORIZONTALE
		speed.y = 0
	velocity = Vector2(speed.x * delta * direction, speed.y * delta * gravityModifier)
	var movement_remainder = move(velocity)
	
	if is_colliding():
		disableMoveLeft = false
		disableMoveRight = false
		var normal = get_collision_normal()
		#On calcule l'angle entre la normal de collision et la normal du sol
		var slope_angle = rad2deg(acos(normal.dot(Vector2(0, -1))))
		#Si l'angle est inférieur à l'angle maximal accepté
#		ATTENTION : ne veut pas dire que nous sommes dans une pente
#		Etre sur le sol valide cette condition (utilisé pour remettre à 0 la gravité)
		if normal == Vector2(0, -1):
			speed.y = 0
		
		if normal == Vector2(0, 1):
			speed.y = 0
		#TENTATIVE WALL JUMP
	#	Cas du wall jump
		if canWallJump:
			if normal == Vector2(1, 0):
				jump_count = 0
				dash_count = 0
				is_on_wall = true
				direction_wall_jump = 1
				speed.y = 0
			elif normal == Vector2(-1, 0):
				jump_count = 0
				dash_count = 0
				is_on_wall = true
				direction_wall_jump = -1
				speed.y = 0
			else:
				is_on_wall = false
		#TENTATIVE WALL JUMP
#		if slope_angle <= MAX_WALKABLE_SLOPE_ANGLE:
#			jump_count = 0
#			#Nous descendons une pente vers la gauche (hardcoded afin d'éviter 
#			un tremblement du joueur)
#			if normal.x < 0 and velocity.x < 0:
#				slide_vector = -normal.tangent()
#				slide_vector = slide_vector.normalized()
#				slide_vector *= velocity.x
#				move(slide_vector)
#				return
#			#Nous descendons une pente vers la droite (hardcoded afin d'éviter 
#			un tremblement du joueur)
#			if normal.x > 0 and velocity.x > 0:
#				slide_vector = -normal.tangent()
#				slide_vector = slide_vector.normalized()
#				slide_vector *= velocity.x
#				move(slide_vector)
#				return
#			Nous sommes dans une pente
#			if slope_angle > 0:
#				revert_motion()
#				speed.y = 0
#				if get_travel().length() < SLIDE_CANCEL_TRESHOLD and velocity.x == 0:
#					movement_remainder = Vector2()$
		if normal == Vector2(0, -1) && gravityModifier == 1 :
			jump_count = 0
			dash_count = 0
		
		if normal == Vector2(0, 1) && gravityModifier == -1 :
			jump_count = 0
			dash_count = 0
		#Si on ne descend pas de pente :
		var final_movement = normal.slide(movement_remainder)
		final_movement = move(final_movement)
	#TENTATIVE WALL JUMP
	else:
		is_on_wall = false
		direction_wall_jump = 0
	#TENTATIVE WALL JUMP
		
func die():
	if !is_dying:
		global.clear_singleton()
		get_tree().reload_current_scene()
		is_dying = true
	
#ON GERE LES INPUTS ICI 

func handleJumpInput(observer, notificationName, notificationData):
	if notificationData == null :
		total_jump_count += 1
	else :
		total_jump_count += notificationData
	sound.play("accepted")
	clearAlphabet(str(notificationName, notificationData))
	var notificationData = {
		"type" : "quantities",
		"name" : "total_jump_count",
		"number" : total_jump_count
	};
	nc.post_notification("variables_modified", notificationData)
	
func handleAddJump(observer, notificationName, notificationData):
	MAX_JUMP_COUNT += 1
	clearAlphabet(notificationName)
	var notificationData = {
		"type" : "abilities",
		"name" : "MAX_JUMP_COUNT",
		"number" : MAX_JUMP_COUNT
	};
	nc.post_notification("variables_modified", notificationData)

func set_jump(j):
	total_jump_count = j
func addDash(observer, notificationName, notificationData):
	if notificationData == null :
		total_dash_count += 1
	else :
		total_dash_count += notificationData
	sound.play("accepted")
	clearAlphabet(str(notificationName, notificationData))
	var notificationData = {
		"type" : "quantities",
		"name" : "total_dash_count",
		"number" : total_dash_count
	};
	nc.post_notification("variables_modified", notificationData)

func addGravity(observer, notificationName, notificationData):
	if notificationData == null :
		total_gravity_count += 1
	else :
		total_gravity_count += notificationData
	sound.play("accepted")
	clearAlphabet(str(notificationName, notificationData))
	var notificationData = {
		"type" : "quantities",
		"name" : "total_gravity_count",
		"number" : total_gravity_count
	};
	nc.post_notification("variables_modified", notificationData)

func enableDoubleJump(observer, notificationName, notificationData):
	if notificationData != null : return
	MAX_JUMP_COUNT = 2
	sound.play("accepted")
	clearAlphabet(str(notificationName, notificationData))
	var notificationData = {
		"type" : "abilities",
		"name" : "MAX_JUMP_COUNT",
		"number" : MAX_JUMP_COUNT
	};
	nc.post_notification("variables_modified", notificationData)

func enableTripleJump(observer, notificationName, notificationData):
	if notificationData != null : return
	MAX_JUMP_COUNT = 3
	sound.play("accepted")
	clearAlphabet(str(notificationName, notificationData))
	var notificationData = {
		"type" : "abilities",
		"name" : "MAX_JUMP_COUNT",
		"number" : MAX_JUMP_COUNT
	};
	nc.post_notification("variables_modified", notificationData)
	
func enableDoubleDash(observer, notificationName, notificationData):
	if notificationData != null : return
	MAX_DASH_COUNT = 2
	sound.play("accepted")
	clearAlphabet(str(notificationName, notificationData))
	var notificationData = {
		"type" : "abilities",
		"name" : "MAX_DASH_COUNT",
		"number" : MAX_DASH_COUNT
	};
	nc.post_notification("variables_modified", notificationData)
	
func enableTripleDash(observer, notificationName, notificationData):
	if notificationData != null : return
	MAX_DASH_COUNT = 3
	sound.play("accepted")
	clearAlphabet(str(notificationName, notificationData))
	var notificationData = {
		"type" : "abilities",
		"name" : "MAX_DASH_COUNT",
		"number" : MAX_DASH_COUNT
	};
	nc.post_notification("variables_modified", notificationData)

func enableWallJump(observer, notificationName, notificationData):
	if notificationData != null : return
	canWallJump = true
	sound.play("accepted")
	clearAlphabet(str(notificationName, notificationData))
	var notificationData = {
		"type" : "abilities",
		"name" : "canWallJump",
		"number" : true
	};
	nc.post_notification("variables_modified", notificationData)
	
func keysound(observer, notificationName, notificationData):
	sound.play(str("clavier_", randi() % 7 + 1))
	print("CLAVIER2")

func rejectedsound(observer, notificationName, notificationData):
	sound.play("rejected")

func remove_label(lettre):
	var j = 0
	var to_remove = []
	# THE BEST WAY TO DO IT !
	for i in childs:
		if i.get_node("Label").get_text().match(lettre) : 
			to_remove.append(j)
			childs.remove(j)
			i.queue_free()
			j -= 1
			return
		j += 1
	#for i in range(to_remove.size()):
	#	childs.remove(i)
		
	
func clearAlphabet(letters_to_delete):
	var indice
	var indiceLabel
	for i in letters_to_delete:
		indice = global.letters_of_player.find(i)
		remove_label(i)
		global.remove(indice, 1)
	nc.post_notification("letters_of_player_modified", null)
	pass

func _on_DashTimer_timeout():
	isDashing = false

func handlePause(observer, notificationName, notificationData):
	set_fixed_process(false)
	set_process_input(false)
	print("pause player")
	pass
	
func handleResume(observer, notificationName, notificationData):
	set_fixed_process(true)
	set_process_input(true)
	print("resume player")
	pass