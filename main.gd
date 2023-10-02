extends Node3D

@onready var level = $Level
@onready var player = $Player

@onready var title_screen = $CanvasLayer/TitleScreen
@onready var game_over_screen = $CanvasLayer/GameOverScreen
@onready var pre_wave_screen = $CanvasLayer/PreWaveScreen

@onready var pre_wave_timer = $PreWaveTimer
@onready var wave_timer = $WaveTimer

@onready var wave_time_label = $CanvasLayer/WaveTime

var wave = 1

func _ready():
    randomize()
    get_tree().paused = true
    title_screen.get_node("Panel/Title/AnimationPlayer").play("cycle")
    

func _physics_process(_delta):
  if player.health <= 0:
    player.ui.visible = false
    wave_time_label.visible = false
    wave = 1
    game_over_screen.visible = true
    game_over_screen.get_node("Panel/Title/AnimationPlayer").play("cycle")
    get_tree().paused = true

func _on_pre_wave_timer_timeout():
  pre_wave_screen.visible = false
  get_tree().paused = false
  wave_timer.start()
  wave_time_label.visible = true
  player.ui.visible = true
  
  
func _on_wave_timer_timeout():
  get_tree().paused = true
  for enemy in get_tree().get_nodes_in_group("enemy"):
    enemy.queue_free()
  wave += 1
  level.get_node("EnemySpawns").spawn_chance += 3
  level.get_node("EnemySpawns").spawn_types = clamp(level.get_node("EnemySpawns").spawn_types, 1, 4)
  pre_wave_screen.get_node("Title").text = "WAVE " + str(wave)
  pre_wave_screen.visible = true
  pre_wave_screen.get_node("Title/AnimationPlayer").play("cycle")
  pre_wave_timer.start()
  

func _on_play_button_pressed():
  title_screen.visible = false
  game_over_screen.visible = false
  pre_wave_screen.visible = true
  pre_wave_screen.get_node("Title/AnimationPlayer").play("cycle")
  pre_wave_timer.start()


func _on_quit_button_pressed():
  get_tree().quit()
