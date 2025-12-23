# ==================================
# Fish Interactive Config
# ==================================
if status is-interactive
    # Remove the default login greeting
    set -g fish_greeting ""
end

# ==================================
# 1. Mise-en-place (Version Manager)
# ==================================
# Initialize mise (replaces nvm, pyenv, jenv, etc.)
# This ensures 'node', 'java', 'gradle' commands work via shims
mise activate fish | source

# ==================================
# 2. Android SDK Configuration
# ==================================
set -gx ANDROID_HOME $HOME/Android/Sdk

# Add Android tools to PATH safely (idempotent)
if test -d $ANDROID_HOME
    fish_add_path $ANDROID_HOME/cmdline-tools/latest/bin
    fish_add_path $ANDROID_HOME/platform-tools
    fish_add_path $ANDROID_HOME/emulator
    fish_add_path $ANDROID_HOME/tools
    fish_add_path $ANDROID_HOME/tools/bin
end

# ==================================
# 3. JAVA_HOME Configuration
# ==================================
# Dynamically set JAVA_HOME to the global Java version managed by Mise.
# 'mise where java' returns the install path (e.g., ~/.local/share/mise/installs/java/...)
set -l mise_java_path (mise where java 2>/dev/null)

if test -n "$mise_java_path"
    set -gx JAVA_HOME $mise_java_path
else
    # Fallback to system java if Mise java is not active
    set -l system_java (readlink -f (which java) 2>/dev/null)
    if test -n "$system_java"
        set -gx JAVA_HOME (dirname (dirname $system_java))
    end
end


set -gx $PROJECT_DIRS $HOME/Projects $HOME/Work $HOME/Code \
    $HOME/projects $HOME/work $HOME/code
set -gx EDITOR zed
# ==================================
# 4. General PATH Additions
# ==================================
# Ensure local bin is in path (common for user scripts)
fish_add_path $HOME/.local/bin
