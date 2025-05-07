set current_theme (cat "$OMF_CONFIG/theme")

if [ "$current_theme" = "bobthefish" ]
  source "$OMF_PATH/themes/bobthefish/fish_right_prompt.fish"

  function fish_right_prompt -d 'bobthefish is all about the right prompt'
    set -l __bobthefish_left_arrow_glyph \uE0B3
    if [ "$theme_powerline_fonts" = "no" ]
      set __bobthefish_left_arrow_glyph '<'
    end

    set_color $fish_color_autosuggestion

    echo -e "\e[A"
    __bobthefish_cmd_duration
    __bobthefish_timestamp
    set_color normal
    echo -e "\e[B"
  end
end
