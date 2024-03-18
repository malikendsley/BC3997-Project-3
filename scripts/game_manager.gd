extends Node2D

@export var start_scene: PackedScene
@onready var fader = %Fader

var start_enabled = false
var current_level = null

func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(fader, "modulate:a", 0, 1)
	await tween.finished
	start_enabled = true
	SigBus.level_cleared.connect(new_level)

func start_game():
	if not start_enabled:
		return
	%Title.queue_free()
	current_level = start_scene.instantiate()
	add_child(current_level)

func new_level(level: PackedScene):
	print("Swapping")
	current_level.queue_free()
	current_level = level.instantiate()
	call_deferred("add_child", current_level)
