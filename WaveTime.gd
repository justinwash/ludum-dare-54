extends Label

@onready var wave_timer = get_node("/root/Main/WaveTimer")

func _physics_process(_delta):
  text = str(int(wave_timer.time_left))
