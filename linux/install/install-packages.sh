#!/usr/bin/env bash
# Linux package installer — reads apt.txt and brew.txt and installs missing packages.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info()    { printf "  [ .. ] %s\n" "$1"; }
success() { printf "  [ OK ] %s\n" "$1"; }
skip()    { printf "  [SKIP] %s\n" "$1"; }
fail()    { printf "  [FAIL] %s\n" "$1"; }

read_pkg_file() {
    local file="$1"
    [[ -f "$file" ]] || return
    while IFS= read -r line; do
        line="${line%%#*}"   # strip comments
        line="${line//[[:space:]]/}"  # trim whitespace
        [[ -z "$line" ]] && continue
        echo "$line"
    done < "$file"
}

install_apt() {
    local pkgfile="$SCRIPT_DIR/apt.txt"
    mapfile -t packages < <(read_pkg_file "$pkgfile")
    [[ ${#packages[@]} -eq 0 ]] && return

    info "Updating apt cache..."
    sudo apt-get update -qq

    echo ""
    echo "[APT]"
    for pkg in "${packages[@]}"; do
        if dpkg -l "$pkg" &>/dev/null; then
            skip "apt: $pkg"
        else
            info "apt: installing $pkg ..."
            if sudo apt-get install -y "$pkg" &>/dev/null; then
                success "apt: $pkg"
            else
                fail "apt: $pkg"
            fi
        fi
    done
}

install_brew() {
    if ! command -v brew &>/dev/null; then
        info "Homebrew not found — skipping brew.txt"
        return
    fi

    local pkgfile="$SCRIPT_DIR/brew.txt"
    mapfile -t packages < <(read_pkg_file "$pkgfile")
    [[ ${#packages[@]} -eq 0 ]] && return

    echo ""
    echo "[Homebrew]"
    for pkg in "${packages[@]}"; do
        if brew list "$pkg" &>/dev/null; then
            skip "brew: $pkg"
        else
            info "brew: installing $pkg ..."
            if brew install "$pkg"; then
                success "brew: $pkg"
            else
                fail "brew: $pkg"
            fi
        fi
    done
}

install_apt
install_brew

echo ""
success "All done!"
