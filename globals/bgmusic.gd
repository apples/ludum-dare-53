extends Node2D

func PlayMenuMusic():
	$Gravity_Way.stop()
	$Gravity_Shoppe.play()
	
	print("Play Shoppe Theme")
	
func PlayGameplayMusic():
	$Gravity_Shoppe.stop()
	$Gravity_Way.play()
	
	print("Play Way Theme")
