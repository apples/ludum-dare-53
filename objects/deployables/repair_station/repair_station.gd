extends "res://objects/deployables/station.gd"


func _on_body_entered(body):
	if body != player_ship:
		return
	
	$Timer.start()
	print("Entered repair field")


func _on_body_exited(body):
	if body != player_ship:
		return
	
	$Timer.stop()
	print("Exited repair field")


func _on_timer_timeout():
	for p in player_ship.packages:
		if p.health < p.initial_health:
			print("Repairing package")
			p.health += 1
			# TODO: effect/sfx
			return
	
	if player_ship.health < player_ship.initial_health:
		player_ship.health += 1
		print("Repairing ship")
		return
	
	print("Nothing to repair")
