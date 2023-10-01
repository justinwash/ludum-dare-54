extends MeshInstance3D

var bullet = preload("res://guns/green/GreenBullet.tscn")
var bullet_speed = 10
@onready var aim_point = get_node("/root/Main/Player/RotationHelper/AimPoint")
@onready var timer = $Timer

var can_fire = true


func fire():
    can_fire = false
    timer.start()
    var new_bullet = bullet.instantiate()
    new_bullet.position = $ProjectileOrigin.position
    new_bullet.velocity = (aim_point.global_position - global_position) * bullet_speed
    add_child(new_bullet)


func _on_timer_timeout():
    can_fire = true
