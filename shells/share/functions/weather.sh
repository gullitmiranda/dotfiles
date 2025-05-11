# Weather forecast
weather() {
	local city="${1:-London}"
	curl -s "wttr.in/${city}?m"
}
