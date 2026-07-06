function php-cs-fixer --description 'Run php-cs-fixer under PHP 8.4 to match Lando/Pantheon'
    # Homebrew's php-cs-fixer shebang points to /opt/homebrew/opt/php/bin/php (the
    # unversioned keg), which may be a newer PHP than 8.4. This intercepts the
    # command and runs the phar directly under php@8.4. Survives brew upgrades.
    set -l phar (find /opt/homebrew/Cellar/php-cs-fixer -name '*.phar' -maxdepth 3 2>/dev/null | sort -V | tail -1)
    /opt/homebrew/opt/php@8.4/bin/php $phar $argv
end
