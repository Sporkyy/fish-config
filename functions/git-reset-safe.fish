function git-reset-safe --description 'Stash changes first, then reset to remote main'
    echo "💾 Stashing local changes first..."
    git stash push -m "Auto-stash before reset "(date); or return $status
    echo "🔄 Fetching latest from origin..."
    git fetch origin; or return $status
    echo "🔄 Resetting to remote main..."
    git reset --hard origin/main; or return $status
    echo "✅ Reset complete. Your changes are saved in stash."
    echo "📋 To recover stashed changes: git stash pop"
end
