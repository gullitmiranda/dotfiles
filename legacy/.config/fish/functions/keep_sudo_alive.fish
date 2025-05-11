function keep_sudo_alive
  # Refresh sudo timeout every 4 minutes
  sudo -v; and sleep 240 &
end
