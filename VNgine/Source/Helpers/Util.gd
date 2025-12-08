class_name Util
extends Node

static func enum_to_str(enum_name: Dictionary, entry: int) -> StringName:
	for key in enum_name:
		if enum_name[key] == entry:
			return StringName("scn_" + key.to_lower())
	return &""

static func print_logo() -> void:
	var logo := [
		"",
		"  ██████╗  █████╗ ██╗    ██╗██████╗ ",
		"  ██╔══██╗██╔══██╗██║    ██║██╔══██╗",
		"  ██████╔╝███████║██║ █╗ ██║██████╔╝",
		"  ██╔══██╗██╔══██║██║███╗██║██╔══██╗",
		"  ██║  ██║██║  ██║╚███╔███╔╝██║  ██║",
		"  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═╝",
		"",
	]
	for line in logo:
		print_rich("[color=red]%s[/color]" % line)
