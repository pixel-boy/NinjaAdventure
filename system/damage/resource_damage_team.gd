@icon("../damage/icon_damage_team.png")
extends Resource
class_name ResourceDamageTeam


enum Team {NEUTRAL,PLAYER,NPC,ENEMY}

@export var team:Team = Team.NEUTRAL
@export var ally_team:Array[Team]
@export var friendly_fire := false


func is_ally(resource_team:ResourceDamageTeam):
	return resource_team.team in ally_team

func is_enemy(resource_team:ResourceDamageTeam):
	return !(resource_team.team in ally_team)
