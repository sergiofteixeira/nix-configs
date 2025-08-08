set -l foreground ebdbb2 normal
set -l command 83a598
set -l param d3869b
set -l keyword fb4934
set -l quote b8bb26
set -l redirection d3869b
set -l end fabd2f
set -l comment 928374 brblack
set -l error fb4934 red
set -l gray 928374
set -l selection 665c54 brcyan
set -l option b8bb26
set -l operator d3869b
set -l escape d3869b
set -l autosuggestion 928374
set -l cancel fb4934
set -l cwd fabd2f
set -l user 8ec07c
set -l host 83a598
set -l host_remote b8bb26
set -l status fb4934

set -l pager_progress 928374
set -l pager_prefix d3869b
set -l pager_completion ebdbb2
set -l pager_description 928374

set -g fish_color_normal $foreground
set -g fish_color_command $command
set -g fish_color_param $param set -g fish_color_keyword $keyword set -g fish_color_quote $quote set -g fish_color_redirection $redirection
set -g fish_color_end $end
set -g fish_color_comment $comment
set -g fish_color_error $error
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_option $option
set -g fish_color_operator $operator
set -g fish_color_escape $escape
set -g fish_color_autosuggestion $autosuggestion
set -g fish_color_cancel $cancel
set -g fish_color_cwd $cwd
set -g fish_color_user $user
set -g fish_color_host $host
set -g fish_color_host_remote $host_remote
set -g fish_color_status $status

set -g fish_pager_color_progress $pager_progress
set -g fish_pager_color_prefix $pager_prefix
set -g fish_pager_color_completion $pager_completion
set -g fish_pager_color_description $pager_description

