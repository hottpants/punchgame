extends CharacterBody3D

class_name Enemy

var enemy_damage : float

func _ready() -> void:
	enemy_damage = 10

func _damage_enemy(damage: float):
	$HealthBarViewport/EnemyHealthBar.set_value($HealthBarViewport/EnemyHealthBar.get_value() - damage)
