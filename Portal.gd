extends Area2D

@export var next_scene: PackedScene

func _on_body_entered(body: Node2D):
    if body is Player:
        SfxManager.play_sfx("cleared")
        SigBus.level_cleared.emit(next_scene)