extends CharacterBody2D

var flip_timer = 0
var flip_time = 1
var flip_variance = 1
var dir = 1
var hp = 3
var flash_time = 0
func _process(_delta):
    flip_timer = move_toward(flip_timer, 0, _delta)
    if flip_timer == 0:
        flip_timer = flip_time + randf() * flip_variance
        dir = -dir

    if dir == 1:
        velocity.x = 100
    else:
        velocity.x = -100
    velocity.y += 1000 * _delta
    if flash_time <= 0:
        modulate = Color(1, 1, 1, 1)
    else:
        flash_time -= _delta
    move_and_slide()

func take_damage():
    hp -= 1
    modulate = Color(10, 10, 10, 1)
    flash_time = 0.15
    if hp <= 0:
        SfxManager.play_sfx("enemy_die")
        queue_free()
    else:
        SfxManager.play_sfx("enemy_hit")

func _on_hit_box_body_entered(body):
    if body is Player:
        body.kill()