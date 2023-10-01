extends ProgressBar

@onready var player = get_node("/root/Main/Player")

func _physics_process(delta):
    value = player.health
