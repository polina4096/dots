if [ -z "$DISPLAY" ] && [ "$(fgconsole)" -eq 1 ]; then
	sudo ~/dev/connect.sh &
	~/sway.sh
fi
