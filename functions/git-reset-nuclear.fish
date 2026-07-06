function git-reset-nuclear --description 'Hard reset + clean untracked files'
    echo "🔄 Fetching latest from origin..."
    git fetch origin
    echo "🚨 Nuclear reset: discarding ALL changes and untracked files..."
    git reset --hard origin/main
    git clean -fd
    echo "✅ Repository completely clean and matches remote"
end
