extends CharacterBody2D
class_name Player

@onready var body_sprite: AnimatedSprite2D = $Sprite
@export var jump_power: float = 500
@export var speed: float = 300
var state = player_states.free
var gravity = 1000
var input_vector = Vector2()
var dash_timer = 0
var next_dash = 0
var was_on_ground = false
@export var dash_cd = 0.25
enum player_states {free, dashing}
@export var bullet_scene: PackedScene
var footstep_timer = 0
var footstep_rate = 0.125
var start_pos = Vector2()

func _ready():
    start_pos = global_position

func _process(delta):
    if Input.is_action_pressed("beam") and state == player_states.free:
        if next_dash <= 0:
            state = player_states.dashing
            dash_timer = .25
            velocity = Vector2(0, 0)
            velocity.x = 500 if input_vector.x > 0 else - 500
            SfxManager.play_sfx("dash")
    elif Input.is_action_pressed("jump") and is_on_floor():
        velocity.y = -jump_power
        SfxManager.play_sfx("jump")
    if Input.is_action_just_pressed("shoot"):
        shoot()
    match state:
        player_states.free:
            # gather input
            input_vector = Vector2()
            # inputs are left and right actions
            input_vector.x += 1 if Input.is_action_pressed("right") else 0
            input_vector.x -= 1 if Input.is_action_pressed("left") else 0
            # move the player
            move(delta)
        player_states.dashing:
            velocity.y = 0
            move_and_slide()
            if dash_timer <= 0:
                state = player_states.free
                next_dash = dash_cd
            else:
                dash_timer = move_toward(dash_timer, 0, delta)
    anim()
    if is_on_floor() and !was_on_ground:
        SfxManager.play_sfx("land")
    was_on_ground = is_on_floor()
    footstep_timer = move_toward(footstep_timer, 0, delta)
    next_dash = move_toward(next_dash, 0, delta)
func move(delta):
    velocity.y += gravity * delta
    velocity.x = move_toward(velocity.x, speed * input_vector.x, 100)
    if velocity.x != 0 and is_on_floor():
        footstep()
    move_and_slide()

func footstep():
    if footstep_timer <= 0:
        SfxManager.play_sfx("footstep")
        footstep_timer = footstep_rate
func anim():
    if velocity.x > 0:
        body_sprite.scale.x = 1
    elif velocity.x < 0:
        body_sprite.scale.x = -1
    else:
        # face the mouse
        if get_global_mouse_position().x > global_position.x:
            body_sprite.scale.x = 1
        else:
            body_sprite.scale.x = -1
    if state == player_states.dashing:
        body_sprite.play("dash")
        return
    if is_on_floor():
        if velocity.x != 0:
            body_sprite.play("run")
        else:
            body_sprite.play("idle")
    else:
        if velocity.y < 0:
            body_sprite.play("jump")
        else:
            body_sprite.play("fall")

# shoot towards mouse
func shoot():
    if state == player_states.dashing:
        return
    SfxManager.play_sfx("shoot")
    var bullet = bullet_scene.instantiate()
    bullet.global_position = global_position + global_position.direction_to(get_global_mouse_position()) * 40
    get_parent().add_child(bullet)
    # move bullet slightly towards mouse
    bullet.velocity = (get_global_mouse_position() - global_position).normalized() * 500

func kill():
    global_position = start_pos
    SfxManager.play_sfx("enemy_die")