function sudo --description 'Mercer-specific: elevate via Privileges.app before sudo'
    if test -x /Applications/Privileges.app/Contents/MacOS/PrivilegesCLI
        /Applications/Privileges.app/Contents/MacOS/PrivilegesCLI --add
    end
    command sudo $argv
end
