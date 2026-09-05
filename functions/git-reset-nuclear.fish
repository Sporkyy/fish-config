function git-reset-nuclear --description 'Hard reset + clean untracked files'
    echo "🔄 Fetching latest from origin..."
    git fetch origin; or return $status
    echo "🚨 Nuclear reset: discarding ALL changes and untracked files..."
    git reset --hard origin/main; or return $status
    git clean -fd; or return $status
    echo "✅ Repository completely clean and matches remote"
end
