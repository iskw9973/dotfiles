# PATH settings
typeset -U path  # Remove duplicates

path=(
  $HOME/.local/bin
  $HOME/bin
  $HOME/.cargo/bin
  $HOME/.deno/bin
  $HOME/.gem/bin
  $HOME/.pub-cache/bin
  $HOME/development/fvm/versions/stable/bin
  $HOME/.maestro/bin
  $HOME/Library/Android/sdk/platform-tools
  $HOME/Library/Android/sdk/cmdline-tools/latest/bin
  $HOME/.nix-profile/bin
  /run/current-system/sw/bin  # nix-darwin のシステムコマンド（darwin-rebuild 等）
  /nix/var/nix/profiles/default/bin
  /opt/homebrew/opt/openjdk@17/bin
  /opt/homebrew/bin
  /opt/homebrew/sbin
  $path
)

export PATH

# Additional environment variables
export ANDROID_HOME=$HOME/Library/Android/sdk
export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"
