#!/usr/bin/env bash
#
# Interactive TUI for installing repo commands as symlinks into ~/.claude/commands/
#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMANDS_DIR="$SCRIPT_DIR/commands"
INSTALL_DIR="$HOME/.claude/commands"

# ANSI escape codes
R=$'\033[0m'
BOLD=$'\033[1m'
DIM=$'\033[2m'
CYAN=$'\033[36m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'

# ── Gather commands ──────────────────────────────────────────────────────────

if [[ ! -d "$COMMANDS_DIR" ]]; then
    echo "Error: commands directory not found at $COMMANDS_DIR" >&2
    exit 1
fi

command_paths=()
while IFS= read -r f; do
    [[ -n "$f" ]] && command_paths+=("$f")
done < <(find "$COMMANDS_DIR" -name "*.md" -maxdepth 1 | sort)

if [[ ${#command_paths[@]} -eq 0 ]]; then
    echo "No commands found in $COMMANDS_DIR" >&2
    exit 1
fi

# Determine install state for each command
names=()
states=()    # "new" | "replace-file" | "replace-link" | "already-linked"
selected=()

for path in "${command_paths[@]}"; do
    name="$(basename "$path" .md)"
    names+=("$name")
    target="$INSTALL_DIR/$name.md"

    if [[ -L "$target" ]]; then
        resolved="$(readlink "$target")"
        if [[ "$resolved" == "$path" ]]; then
            states+=("already-linked")
            selected+=(0)
        else
            states+=("replace-link")
            selected+=(1)
        fi
    elif [[ -e "$target" ]]; then
        states+=("replace-file")
        selected+=(1)
    else
        states+=("new")
        selected+=(1)
    fi
done

num_items=${#names[@]}
cursor=0

# ── Terminal helpers ─────────────────────────────────────────────────────────

_hide_cursor()       { printf '\033[?25l'; }
_show_cursor()       { printf '\033[?25h'; }
_enter_alt_screen()  { printf '\033[?1049h'; }
_exit_alt_screen()   { printf '\033[?1049l'; }
_clear_screen()      { printf '\033[2J\033[H'; }

_cleanup() {
    _show_cursor
    _exit_alt_screen
}
trap _cleanup EXIT INT TERM

# ── Render ───────────────────────────────────────────────────────────────────

_render() {
    _clear_screen

    # Find longest name for alignment
    local maxlen=0
    for n in "${names[@]}"; do
        [[ ${#n} -gt $maxlen ]] && maxlen=${#n}
    done
    local col_w=$(( maxlen + 2 ))

    printf "\n"
    printf "  %b\n" "${BOLD}${CYAN}? Select commands to install as symlinks${R}"
    printf "  %b\n" "${DIM}  → $INSTALL_DIR${R}"
    printf "\n"
    printf "  %b\n" "${DIM}↑↓ navigate  SPACE toggle  a toggle all  ENTER install  q quit${R}"
    printf "\n"

    local i
    for i in "${!names[@]}"; do
        local name="${names[$i]}"
        local state="${states[$i]}"
        local sel="${selected[$i]}"

        # Cursor indicator
        if [[ $i -eq $cursor ]]; then
            local pfx=" ${CYAN}${BOLD}❯${R} "
        else
            local pfx="   "
        fi

        # Checkbox symbol
        if [[ $sel -eq 1 ]]; then
            local chk="${GREEN}◉${R}"
        else
            local chk="${DIM}◯${R}"
        fi

        # State badge
        local badge
        case "$state" in
            new)            badge="${GREEN}new${R}" ;;
            replace-file)   badge="${YELLOW}REPLACE existing file${R}" ;;
            replace-link)   badge="${YELLOW}REPLACE existing symlink${R}" ;;
            already-linked) badge="${DIM}already installed${R}" ;;
        esac

        printf "%b%b  %-*s  %b\n" "$pfx" "$chk" "$col_w" "$name" "$badge"
    done

    printf "\n"
    printf "  %s\n" "$(printf '─%.0s' {1..54})"

    # Count selected
    local count=0
    for s in "${selected[@]}"; do [[ $s -eq 1 ]] && (( count++ )) || true; done

    printf "\n"
    if [[ $count -eq 0 ]]; then
        printf "  %b\n" "${DIM}No commands selected${R}"
    else
        printf "  %b\n" "${BOLD}${GREEN}$count command(s) selected${R}  — press ENTER to install"
    fi
    printf "\n"
}

# ── Main TUI loop ────────────────────────────────────────────────────────────

_enter_alt_screen
_hide_cursor

while true; do
    _render

    IFS= read -r -s -n1 key

    # Arrow keys arrive as 3-byte escape sequences
    if [[ "$key" == $'\x1b' ]]; then
        IFS= read -r -s -n1 -t 0.05 k2
        if [[ "$k2" == "[" ]]; then
            IFS= read -r -s -n1 -t 0.05 k3
            case "$k3" in
                A)  # Up
                    (( cursor-- )) || true
                    [[ $cursor -lt 0 ]] && cursor=$(( num_items - 1 ))
                    ;;
                B)  # Down
                    (( cursor++ )) || true
                    [[ $cursor -ge $num_items ]] && cursor=0
                    ;;
            esac
        fi
        continue
    fi

    case "$key" in
        " ")
            if [[ "${selected[$cursor]}" -eq 1 ]]; then
                selected[$cursor]=0
            else
                selected[$cursor]=1
            fi
            ;;
        a|A)
            all_sel=1
            for s in "${selected[@]}"; do [[ $s -eq 0 ]] && { all_sel=0; break; }; done
            if [[ $all_sel -eq 1 ]]; then
                for i2 in "${!selected[@]}"; do selected[$i2]=0; done
            else
                for i2 in "${!selected[@]}"; do selected[$i2]=1; done
            fi
            ;;
        "")  # Enter
            break
            ;;
        q|Q)
            _exit_alt_screen
            _show_cursor
            printf "Aborted.\n"
            exit 0
            ;;
    esac
done

# ── Install ──────────────────────────────────────────────────────────────────

_exit_alt_screen
_show_cursor

mkdir -p "$INSTALL_DIR"

printf "\n"
printf "  %b\n\n" "${BOLD}Installing...${R}"

installed=0
skipped=0
errors=0

for i in "${!names[@]}"; do
    local_sel="${selected[$i]}"
    name="${names[$i]}"
    src="${command_paths[$i]}"
    target="$INSTALL_DIR/$name.md"
    state="${states[$i]}"

    if [[ $local_sel -ne 1 ]]; then
        printf "  %b  %s\n" "${DIM}skip${R}     " "$name"
        (( skipped++ )) || true
        continue
    fi

    # Remove existing target if present
    if [[ -e "$target" || -L "$target" ]]; then
        rm "$target" 2>/dev/null || {
            printf "  %b  %s  (could not remove existing file)\n" "${RED}error${R}" "$name"
            (( errors++ )) || true
            continue
        }
    fi

    if ln -s "$src" "$target" 2>/dev/null; then
        case "$state" in
            already-linked) printf "  %b  %s\n" "${GREEN}relinked${R} " "$name" ;;
            replace-*)      printf "  %b  %s\n" "${YELLOW}replaced${R} " "$name" ;;
            new)            printf "  %b  %s\n" "${GREEN}installed${R}" "$name" ;;
        esac
        (( installed++ )) || true
    else
        printf "  %b  %s\n" "${RED}error${R}    " "$name"
        (( errors++ )) || true
    fi
done

printf "\n  %s\n" "$(printf '─%.0s' {1..54})"
printf "\n"

if [[ $errors -gt 0 ]]; then
    printf "  %b\n\n" "${RED}Done with errors: $installed installed, $skipped skipped, $errors errors${R}"
else
    printf "  %b\n\n" "${GREEN}Done: $installed installed, $skipped skipped${R}"
fi
