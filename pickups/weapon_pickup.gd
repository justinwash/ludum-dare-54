extends RigidBody3D

var weapon_types = {
    "RedGun": preload("res://guns/red/RedGun.tscn"),
    "GreenGun": preload("res://guns/green/GreenGun.tscn"),
    "PurpleGun": preload("res://guns/purple/PurpleGun.tscn"),
    "OrangeGun": preload("res://guns/orange/OrangeGun.tscn"),
}

@export var pickup_type = "RedGun"

func _ready():
    for mesh in $Meshes.get_children():
        if pickup_type in str(mesh.name):
            mesh.visible = true
        else:
            mesh.visible = false


func _on_area_3d_body_entered(body):
    if "Player" in str(body.name) and body.weapon_holder.get_child(0).name != pickup_type:
        body.weapon_holder.get_child(0).queue_free()
        var new_weapon = weapon_types[pickup_type].instantiate()
        new_weapon.position = Vector3(0,0,0)
        body.weapon_holder.add_child(new_weapon)
        self.queue_free()
