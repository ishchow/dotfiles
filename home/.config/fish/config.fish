if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Start ssh-agent if not already running
if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c)
end

zoxide init fish | source
starship init fish | source
