# Java
#############
# set JAVA_HOME and JDK_HOME
if test -e ~/.asdf/plugins/java/set-java-home.fish
    source ~/.asdf/plugins/java/set-java-home.fish
end

# Android
# https://ionicframework.com/docs/developing/android#configuring-command-line-tools
# https://developer.android.com/tools
########################
set -gx ANDROID_HOME $HOME/Library/Android/sdk
set -gx ANDROID_SDK_ROOT $HOME/Library/Android/sdk

if test -d "$ANDROID_HOME"
  # avdmanager, sdkmanager
  contains $ANDROID_HOME/cmdline-tools/latest/bin $PATH; or set -gx PATH $PATH $ANDROID_HOME/cmdline-tools/latest/bin
  # adb, logcat
  contains $ANDROID_HOME/platform-tools $PATH; or set -gx PATH $PATH $ANDROID_HOME/platform-tools
  # emulator
  contains $ANDROID_HOME/emulator $PATH; or set -gx PATH $PATH $ANDROID_HOME/emulator
end
