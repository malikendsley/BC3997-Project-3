extends Node2D

func _ready():
    await get_tree().create_timer(2).timeout
    var tween = get_tree().create_tween()
    tween.tween_property( %Control, "modulate:a", 0, 1)
    await tween.finished