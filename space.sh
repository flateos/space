#! /bin/bash

# Copyright (c) 2021 Romullo @hiukky.

# This file is part of FlateOS
# (see https://github.com/flateos).

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

set -eE

declare -a PKGS=${@}

PKG_DIR=$PWD/space/pkgbuilds
OUT_DIR=$PWD/space/x86_64

function make_pkg() {
    for pkg in $PKGS; do
        printf "\n\nBuilding the package: $pkg\n\n"
        cd "$PKG_DIR/$pkg" && updpkgsums && makepkg --sign -f -c
    done
}

function update_db() {
    repo-add -s -v -n -R $OUT_DIR/space.db.tar.gz $OUT_DIR/*pkg.tar.zst
}

function main() {
    [ -n "$PKGS" ] && make_pkg

    update_db

    printf "\n\nSpace updated successfully!\n\n"
}

main
