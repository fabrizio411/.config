# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/dev/pinerolo"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "pinerolo"; then

  new_window "editor"
  new_window "server"

  select_window "server"
  split_h 50
  select_pane 0

  select_window "editor"
  run_cmd "nvim"

  select_window 2

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
