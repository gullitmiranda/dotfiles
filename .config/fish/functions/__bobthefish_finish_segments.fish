# Defined in ./fish_prompt.fish @ line 302
function __bobthefish_finish_segments --description 'Close open prompt segments' --no-scope-shadowing
  if [ -n "$__bobthefish_current_bg" ]
    set_color normal
    set_color $__bobthefish_current_bg
    echo -ns $__bobthefish_right_black_arrow_glyph ' '
  end

  if [ "$theme_newline_cursor" = 'yes' ]
    echo -ens "\n"
    set_color $fish_color_autosuggestion
    if [ -n "$theme_newline_chart" ]
      echo -ns "$theme_newline_chart "
    else if [ "$theme_powerline_fonts" = "no" ]
      echo -ns '> '
    else
      echo -ns "$right_arrow_glyph "
    end
  else if [ "$theme_newline_cursor" = 'clean' ]
    echo -ens "\n"
  end

  set_color normal
  set __bobthefish_current_bg
end
