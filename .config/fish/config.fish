set -x LC_ALL en_US.UTF-8
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f $HOME/.config/yarn/global/node_modules/serverless/node_modules/tabtab/.completions/serverless.fish ]; and . $HOME/.config/yarn/global/node_modules/serverless/node_modules/tabtab/.completions/serverless.fish
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f $HOME/.config/yarn/global/node_modules/serverless/node_modules/tabtab/.completions/sls.fish ]; and . $HOME/.config/yarn/global/node_modules/serverless/node_modules/tabtab/.completions/sls.fish
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[ -f $HOME/.config/yarn/global/node_modules/serverless/node_modules/tabtab/.completions/slss.fish ]; and . $HOME/.config/yarn/global/node_modules/serverless/node_modules/tabtab/.completions/slss.fish
set -g fish_user_paths "/usr/local/opt/helm@2/bin" $fish_user_paths
