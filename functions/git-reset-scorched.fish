function git-reset-scorched --description 'Reset + clean everything including ignored files'
    echo "🔄 Fetching latest from origin..."
    git fetch origin; or return $status
    echo "💥 SCORCHED EARTH: removing EVERYTHING not in git..."
    git reset --hard origin/main; or return $status
    git clean -fdx; or return $status
    echo "🔥 Repository completely scorched and rebuilt from remote"
end
