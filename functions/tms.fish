function tms --description "A Fish shell plugin for managing git projects as tmux sessions"
    set -l selected

    # Check if an argument (repo path) was provided
    if test (count $argv) -eq 1
        set -l repo_path $argv[1]
        set -l ghq_root (ghq root)
        set -l full_path $ghq_root/github.com/$repo_path

        # Clone the repo if it doesn't exist locally
        if not test -d $full_path
            echo "Repository not found. Attempting to clone with ghq..."
            ghq get $repo_path
            if test $status -ne 0
                echo "Failed to clone repository."
                return 1
            end
        end
        set selected $full_path
    else
        # If no argument, use fzf to select from ghq list
        set selected (ghq list -p | fzf)
    end

    # Exit if no repository was selected
    if test -z "$selected"
        return 0
    end

    # Create a tmux session name from the repository name
    set -l selected_name (basename "$selected" | tr . _)

    # Check if tmux is running
    set -l tmux_running (pgrep tmux)

    # If tmux is not running, start a new session
    if test -z "$TMUX" -a -z "$tmux_running"
        tmux new-session -s $selected_name -c $selected
        return 0
    end

    # If the session doesn't exist, create it
    if not tmux has-session -t=$selected_name 2>/dev/null
        tmux new-session -ds $selected_name -c $selected
    end

    # Switch to the session
    tmux switch-client -t $selected_name
end
