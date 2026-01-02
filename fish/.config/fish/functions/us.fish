function us
    set -lx ASDF_NODEJS_VERSION 10.15.2
    npm --prefix ~/dev/intern/uranus/app/vue start $argv
end

# ~/.config/fish/functions/uw.fish
function uw
    set -lx ASDF_NODEJS_VERSION 10.15.2
    npm --prefix ~/dev/intern/uranus/app/vue run watch $argv
end
