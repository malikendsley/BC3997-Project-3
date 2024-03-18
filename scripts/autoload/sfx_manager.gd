extends Node

# Key : Preloaded SFX
var sfx_pool_size = 5

var sfx = {
    "dash": preload ("res://assets/sounds/Dash.wav"),
    "die": preload ("res://assets/sounds/Die.wav"),
    "footstep": preload ("res://assets/sounds/Footstep.wav"),
    "jump": preload ("res://assets/sounds/Jump.wav"),
    "land": preload ("res://assets/sounds/Land.wav"),
    "shoot": preload ("res://assets/sounds/Shoot.wav"),
    "enemy_hit": preload ("res://assets/sounds/EnemyHit.wav"),
    "enemy_die": preload ("res://assets/sounds/EnemyDie.wav"),
    "cleared": preload ("res://assets/sounds/Cleared.wav"),
    "sad": preload ("res://assets/sounds/music/sad.mp3")
}

func _ready():
    for i in range(sfx_pool_size):
        var sfx_player = AudioStreamPlayer.new()
        sfx_player.name = "sfx_player_" + str(i)
        add_child(sfx_player)

func get_from_pool():
    for i in range(sfx_pool_size):
        var sfx_player = get_node("sfx_player_"+ str(i))
        if not sfx_player.is_playing():
            return sfx_player
    return null

func play_sfx(sfx_key):
    if sfx.has(sfx_key):
        var sfx_player = get_from_pool()
        if sfx_player:
            sfx_player.stream = sfx[sfx_key]
            sfx_player.play()
    else:
        push_error("SFX not found: " + sfx_key)
