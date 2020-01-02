extends Node2D
tool

func getChar(index):
	return get_child(index).duplicate() 