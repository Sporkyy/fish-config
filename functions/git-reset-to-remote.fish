function git-reset-to-remote --description 'Hard reset to any remote branch (pass branch name as argument)'
    set -l branch $argv[1]
    if test -z "$branch"
        set branch main
    end
    echo "🔄 Fetching latest from origin..."
    git fetch origin; or return $status
    echo "🚨 Hard reset to origin/$branch (this will discard ALL local changes)..."
    git reset --hard origin/$branch; or return $status
    echo "✅ Local branch now matches remote $branch exactly"
end
