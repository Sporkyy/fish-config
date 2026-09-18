function php-cs-fixer --description 'Run php-cs-fixer under PHP 8.5 to match Lando/Pantheon'
    # Prefer Homebrew's PHP 8.5 executable because the formula's unversioned
    # shebang may select a newer PHP. Fall back to the installed command on
    # systems without that Homebrew layout.
    if type -q brew
        set -l php_prefix (brew --prefix php@8.5 2>/dev/null)
        set -l fixer_prefix (brew --prefix php-cs-fixer 2>/dev/null)
        set -l php_bin "$php_prefix/bin/php"

        if test -x "$php_bin"; and test -d "$fixer_prefix"
            set -l phar (find -H "$fixer_prefix" -maxdepth 3 -name '*.phar' 2>/dev/null | head -n 1)
            if test -n "$phar"
                "$php_bin" "$phar" $argv
                return $status
            end
        end
    end

    command php-cs-fixer $argv
end
