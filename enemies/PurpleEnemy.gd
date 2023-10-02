extends CharacterBody3D

@export var SPEED = 8.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var player = get_node("/root/Main/Player")

func _physics_process(delta):
    if not is_on_floor():
        velocity.y -= gravity * delta

    var direction = (player.global_position - self.global_position).normalized()
    if direction:
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED

    move_and_slide()


func _on_area_3d_body_entered(body):
    if "Player" in str(body.name):
        body.hurt(10)
        self.queue_free()  
    
    if "PurpleBullet" in str(body.name):
        self.queue_free()
        body.queue_free()
