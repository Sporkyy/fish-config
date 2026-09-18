function git-reset-hard --description 'Hard reset to remote main branch (discards all local changes)'
    echo "🔄 Fetching latest from origin..."
    git fetch origin; or return $status
    echo "🚨 Hard reset to origin/main (this will discard ALL local changes)..."
    git reset --hard origin/main; or return $status
    echo "✅ Local branch now matches remote main exactly"
end
