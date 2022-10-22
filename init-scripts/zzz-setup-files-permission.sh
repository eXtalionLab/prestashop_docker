#!/usr/bin/env bash

# Name starts with "zzz" to be sure that script runs last and all files will
# have good permission!

echo "Setup files permission..."

setfacl -R -m u:www-data:rwX -m u:"$(whoami)":rwX .
setfacl -dR -m u:www-data:rwX -m u:"$(whoami)":rwX .
