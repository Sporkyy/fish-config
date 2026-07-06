function git-reset-scorched --description 'Reset + clean everything including ignored files'
    echo "🔄 Fetching latest from origin..."
    git fetch origin
    echo "💥 SCORCHED EARTH: removing EVERYTHING not in git..."
    git reset --hard origin/main
    git clean -fdx
    echo "🔥 Repository completely scorched and rebuilt from remote"
end
