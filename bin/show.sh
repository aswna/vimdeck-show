#!/usr/bin/env bash

set -e
set -u

# some box drawing characters (see the full list at the end of this file)
# ┌─┬─┐ ╭─┬─╮
# ├─┼─┤ ├─┼─┤
# └─┴─┘ ╰─┴─╯
# some dots, circles, and boxes
# ·･•⚫⬤● ⚬⚪￮○ ◌
# ░ █ ▄ ▀

FILEPATH=$(readlink -f "${BASH_SOURCE[0]}")
SCRIPT_DIR=$(cd "$(dirname "${FILEPATH}")" && pwd)
REAL_BASE_DIR=$(cd "${SCRIPT_DIR}"/.. && pwd)

main() {
    parse_command_line_arguments ${*}
    clean_up
    generate
    replace_hand_made_files
    insert_top_margin_to_files
    customize_vim_script
    open_it_up
}

parse_command_line_arguments() {
    if [ ${#} -ne 1 ]; then
        print_help
        exit 1
    fi

    if [ ! -d "${1}" ]; then
        echo "Directory ${1} does not exist!" >&2
        exit 1
    fi
    cd "${1}"
    PRESENTATION_BASE_DIR=$(pwd)
}

print_help() {
    cat >&2 <<EOF
Usage: show.sh <directory>
    directory      contains the presentation file (slides.md) and
                   optionally the hand-made files (hm_*.md)
EOF
}

clean_up() {
    rm -rf presentation
}

generate() {
    vimdeck generate --header-font threepoint --header-margin 2 --padding 2 slides.md
}

insert_top_margin_to_files() {
    for f in presentation/*.md; do
        if [ -r "${f}" ]; then
            sed -i '1s/^/\n\n/' "${f}"
        fi
    done
}

replace_hand_made_files() {
    for f in hm_*.md; do
        if [ -r "${f}" ]; then
            local to_be_replaced="${f#hm_}"
            cp "${f}" presentation/"${to_be_replaced}"
        fi
    done

    local last_slide="last_slide.md"
    if [ ! -r "${last_slide}" ]; then
        last_slide="${REAL_BASE_DIR}/etc/${last_slide}"
    fi
    cp "${last_slide}" presentation/slide999.md
}

customize_vim_script() {
    local tmp_vim_script=/tmp/script.vim

    cat "${REAL_BASE_DIR}"/etc/script_pre.vim > ${tmp_vim_script}
    echo >> ${tmp_vim_script}

    cat >> "${tmp_vim_script}" <<EOF
" ----------------------------
" vimdeck generated script.vim
" ----------------------------

EOF

    cat presentation/script.vim >> "${tmp_vim_script}"
    echo >> ${tmp_vim_script}

    cat "${REAL_BASE_DIR}"/etc/script_post.vim >> ${tmp_vim_script}
    echo >> ${tmp_vim_script}

    local custom_vim_script="${PRESENTATION_BASE_DIR}"/script.vim
    if [ -r "${custom_vim_script}" ]; then
        cat >> "${tmp_vim_script}" <<EOF
" -----------------
" custom script.vim
" -----------------

EOF

        cat "${custom_vim_script}" >> "${tmp_vim_script}"
    fi

    mv "${tmp_vim_script}" presentation/script.vim
}

open_it_up() {
    vimdeck open
}

main ${*}

# https://en.wikipedia.org/wiki/Box-drawing_character#Unicode
#            0 1 2 3 4 5 6 7 8 9 A B C D E F
#
#    U+250x  ─ ━ │ ┃ ┄ ┅ ┆ ┇ ┈ ┉ ┊ ┋ ┌ ┍ ┎ ┏
#
#    U+251x  ┐ ┑ ┒ ┓ └ ┕ ┖ ┗ ┘ ┙ ┚ ┛ ├ ┝ ┞ ┟
#
#    U+252x  ┠ ┡ ┢ ┣ ┤ ┥ ┦ ┧ ┨ ┩ ┪ ┫ ┬ ┭ ┮ ┯
#
#    U+253x  ┰ ┱ ┲ ┳ ┴ ┵ ┶ ┷ ┸ ┹ ┺ ┻ ┼ ┽ ┾ ┿
#
#    U+254x  ╀ ╁ ╂ ╃ ╄ ╅ ╆ ╇ ╈ ╉ ╊ ╋ ╌ ╍ ╎ ╏
#
#    U+255x  ═ ║ ╒ ╓ ╔ ╕ ╖ ╗ ╘ ╙ ╚ ╛ ╜ ╝ ╞ ╟
#
#    U+256x  ╠ ╡ ╢ ╣ ╤ ╥ ╦ ╧ ╨ ╩ ╪ ╫ ╬ ╭ ╮ ╯
#
#    U+257x  ╰ ╱ ╲ ╳ ╴ ╵ ╶ ╷ ╸ ╹ ╺ ╻ ╼ ╽ ╾ ╿
