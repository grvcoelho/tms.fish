function tms --description "A fish-shell plugin for managing git projects as tmux sessions (v1.0.0)"
    set -l selected

    if test (count $argv) -eq 0
        # No arguments: open fzf to select from all ghq repositories
        set selected (ghq list -p | fzf)
    else if test -d $argv[1]
        # If argument is an existing directory, use it directly
        set selected $argv[1]
    else if string match -q "*/*" $argv[1]
        # If argument looks like a repo path (contains '/'), try to clone or use existing
        set -l repo_path $argv[1]
        set -l ghq_root (ghq root)
        set -l full_path $ghq_root/github.com/$repo_path

        # Clone the repository if it doesn't exist locally
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
        # For any other input, use it as a search query in fzf
        set selected (ghq list -p | fzf -q "$argv[1]" -1)
    end

    # Exit if no repository was selected
    if test -z "$selected"
        return 0
    end

    # Create a tmux session name from the repository name
    set -l selected_name (basename "$selected" | tr . _)

    # Check if tmux is running
    set -l tmux_running (pgrep tmux)

    # If tmux is not running, start a new session and attach to it
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
