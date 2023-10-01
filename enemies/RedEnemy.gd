extends CharacterBody3D

@export var SPEED = 8.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var weapon_pickup = preload("res://pickups/WeaponPickup.tscn")

@onready var player = get_node("/root/Main/Player")

func _physics_process(delta):
    if not is_on_floor():
        velocity.y -= gravity * delta

    var direction = (player.global_position - self.global_position).normalized()
    if direction:
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)

    move_and_slide()


func _on_area_3d_body_entered(body):
    if "Player" in str(body.name):
        body.hurt(10)
        var bounce_direction = (self.global_position - player.global_position).normalized()
        if bounce_direction:
            velocity.x = bounce_direction.x * SPEED * 5
            velocity.z = bounce_direction.z * SPEED * 5    
    
    if "RedBullet" in str(body.name):
        self.queue_free()
        body.queue_free()
