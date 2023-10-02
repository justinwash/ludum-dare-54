extends Node3D

var tick = 0

@onready var spawners = get_children()

var enemy_types = [
  preload("res://enemies/GreenEnemy.tscn"),
  preload("res://enemies/RedEnemy.tscn"),
  preload("res://enemies/OrangeEnemy.tscn"),
  preload("res://enemies/PurpleEnemy.tscn"),
]

@export var spawn_chance = 0
@export var spawn_types = 4

func _physics_process(_delta):
  if tick % 30 == 0:
    for spawner in spawners:
      var spawn_roll = randi() % 101
      print(spawn_roll, " ", spawn_roll < spawn_chance)
      if spawn_roll < spawn_chance:
        var new_enemy = enemy_types[randi() % spawn_types].instantiate()
        new_enemy.position = Vector3(0,0,0)
        spawner.add_child(new_enemy)
  
  tick += 1
