class_name Rope
extends Line2D


func cast(start: Vector2, end: Vector2) -> void:
	add_point(start)
	add_point(end)
	print("hi, the start is at " + str(start) + " and the end is at " + str(end))
