# Generate a random password
function genpass
    set -l length 16
    if test (count $argv) -gt 0
        set length $argv[1]
    end
    LC_ALL=C tr -dc 'A-Za-z0-9_!@#$%^&*()-+=' </dev/urandom | head -c $length | xargs
end
