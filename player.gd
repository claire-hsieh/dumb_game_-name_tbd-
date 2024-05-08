extends Area2D
signal hit 
#  defines a custom signal called "hit" that we will have our player emit (send out) when it collides with an enemy
# use Area2D to detect the collision. 

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	# delta refers to frame length (time) 
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# choose animation 
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		# $AnimatedSprite2D.flip_v = velocity.y > 0



func _on_body_entered(body):
	# green icon indicating that a signal is connected to this function
	# this does not mean the function exists, only that the signal will attempt to connect to a function with that name,
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	# reset the player when starting a new game.
	position = pos
	show()
	$CollisionShape2D.disabled = false
