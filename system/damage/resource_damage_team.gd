@icon("../damage/icon_resource_damage_team.png")
extends Resource
class_name ResourceDamageTeam


@export var ally_team:Array[ResourceDamageTeam]
@export var enemy_team:Array[ResourceDamageTeam]
@export var friendly_fire := false


func is_ally_team(team:ResourceDamageTeam):
	return team in ally_team

func is_enemy_team(team:ResourceDamageTeam):
	return team in enemy_team
