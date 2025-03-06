extends Node

@export var base_attack_damage: int
@export_range(0.1, 5.0) var mulitplier

signal on_attack
