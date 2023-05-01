extends Node2D

func PlayMenuMusic():
	if $Gravity_Shoppe.playing:
		return
	
	$Gravity_Way.stop()
	$Gravity_Shoppe.play()
	
	print("Play Shoppe Theme")
	
func PlayGameplayMusic():
	if $Gravity_Way.playing:
		return
	
	$Gravity_Shoppe.stop()
	$Gravity_Way.play()
	
	print("Play Way Theme")
