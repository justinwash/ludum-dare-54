extends CharacterBody3D

const SPEED = 15.0
const ACCEL = 1.0

var can_fire = true
@onready var weapon_holder = $RotationHelper/WeaponHolder

@onready var camera = get_node("/root/Main/Camera3D")

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var weapon_pickup = preload("res://pickups/WeaponPickup.tscn")

var health = 100
var invuln = false

func _physics_process(delta):
    if not is_on_floor():
        velocity.y -= gravity * delta

    var input_dir = Input.get_vector("left", "right", "up", "down")
    var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    if direction:
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)
        
    if Input.is_action_pressed("fire") && weapon_holder.get_child_count() > 0:
        var weapon = weapon_holder.get_child(0)
        if weapon && weapon.can_fire:
            weapon.fire()

    move_and_slide()
    

func hurt(damage):
    $AnimationPlayer.play("hurt")
    health -= damage
    if health <= 0:
        print("you lose")
    
    
func throw_weapon(weapon_type):
    var new_pickup: RigidBody3D = weapon_pickup.instantiate()
    new_pickup.pickup_type = weapon_type
    new_pickup.name = str(weapon_type).replace("Gun", "Pickup")
    get_node("/root/Main/Level1").add_child(new_pickup)
    new_pickup.global_position = $RotationHelper/PickupOrigin.global_position
    new_pickup.apply_central_impulse(($RotationHelper/PickupOrigin.global_position - self.global_position) * 5)
    
    
func _input(event):
    var viewport := get_viewport()
    var mouse_position := viewport.get_mouse_position()
    var camera := viewport.get_camera_3d()  
    var origin := camera.project_ray_origin(mouse_position)
    var direction := camera.project_ray_normal(mouse_position)
    var ray_length := camera.far
    var end := origin + direction * ray_length
    var space_state := get_world_3d().direct_space_state
    var query := PhysicsRayQueryParameters3D.create(origin, end)
    var result := space_state.intersect_ray(query)
    var mouse_position_3D:Vector3 = result.get("position", end)
    $RotationHelper.look_at(mouse_position_3D)
    $RotationHelper.global_rotation = Vector3(0.0, $RotationHelper.global_rotation.y, $RotationHelper.global_rotation.z)
