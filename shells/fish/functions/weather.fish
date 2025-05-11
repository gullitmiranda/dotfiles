# Weather forecast
function weather
    set -l city London
    if test (count $argv) -gt 0
        set city $argv[1]
    end
    curl -s "wttr.in/$city?m"
end
