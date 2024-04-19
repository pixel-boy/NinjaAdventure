extends Resource
class_name ResourceWeapon


enum AnimationType {SLASH,PIERCING,RANGE}

@export var sprite:Texture2D
@export var sprite_in_hand:Texture2D
@export var anim_type:AnimationType = AnimationType.SLASH
@export var damage:ResourceDamage
