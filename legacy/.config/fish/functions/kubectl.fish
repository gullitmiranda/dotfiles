
# function kubectl
#   set __kubectl_native (which kubectl)
#   set -q KUBECTL_CONTEXT; or set KUBECTL_CONTEXT (eval $__kubectl_native config current-context)
#   set argv --context=$KUBECTL_CONTEXT $argv
#   set -q KUBECTL_NAMESPACE; and set argv --namespace=$KUBECTL_NAMESPACE $argv

#   eval $__kubectl_native $argv
# end
