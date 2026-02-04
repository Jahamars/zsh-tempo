# Tempo - Minimalist Time Progress Tracker for Zsh
# https://github.com/Jahamars/tempo

unalias tempo 2>/dev/null

# Required for hooks
autoload -Uz add-zsh-hook

# Helper to get configuration with backward compatibility for 'TBT_'
_tempo_get_config() {
    local var_name=$1
    local default_val=$2
    local legacy_name="${var_name/TEMPO_/TBT_}"
    
    local val="${(P)var_name}"
    [[ -z "$val" ]] && val="${(P)legacy_name}"
    
    echo "${val:-$default_val}"
}

# Core progress drawing function
_tempo_draw() {
    local val=$1
    local max=$2
    local label=$3
    
    local width=$(_tempo_get_config TEMPO_WIDTH 40)
    local char_filled=$(_tempo_get_config TEMPO_FILLED_CHAR "█")
    local char_empty=$(_tempo_get_config TEMPO_EMPTY_CHAR "░")
    local use_color=$(_tempo_get_config TEMPO_COLOR_STYLE "true")
    
    local percent=$((val * 100 / max))
    (( percent > 100 )) && percent=100
    
    local filled=$((width * percent / 100))
    local empty=$((width - filled))

    local color=""
    if [[ "$use_color" == "true" ]]; then
        if (( percent >= 90 )); then
            color='%F{red}'
        elif (( percent >= 70 )); then
            color='%F{yellow}'
        else
            color='%F{blue}'
        fi
    fi

    local bar_filled=""
    local bar_empty=""
    for ((i = 0; i < filled; i++)); do bar_filled+="$char_filled"; done
    for ((i = 0; i < empty; i++)); do bar_empty+="$char_empty"; done

    local padding_size=$(( 7 - ${#label} ))
    local padding=""
    for ((i = 0; i < padding_size; i++)); do padding+=" "; done

    print -P "${label}${padding}: [${color}${bar_filled}%f${bar_empty}] ${percent}%%"
}

# Time calculation wrappers
_tempo_calc_day() {
    local curr=$(( $(date +%-k 2>/dev/null || date +%-H)*3600 + $(date +%-M)*60 + $(date +%-S) ))
    _tempo_draw "$curr" 86400 "Day"
}

_tempo_calc_week() {
    local dow=$(date +%u)
    local curr=$(( (dow - 1) * 86400 + $(date +%-k 2>/dev/null || date +%-H)*3600 + $(date +%-M)*60 + $(date +%-S) ))
    _tempo_draw "$curr" 604800 "Week"
}

_tempo_calc_month() {
    local day=$(date +%-d)
    local days_in_month=$(date -d "$(date +%Y-%m-01) +1 month -1 day" +%-d 2>/dev/null || gdate -d "$(date +%Y-%m-01) +1 month -1 day" +%-d 2>/dev/null || echo 30)
    local curr=$(( (day - 1) * 86400 + $(date +%-k 2>/dev/null || date +%-H)*3600 + $(date +%-M)*60 + $(date +%-S) ))
    _tempo_draw "$curr" $((days_in_month * 86400)) "Month"
}

_tempo_calc_year() {
    local doy=$(date +%-j)
    local year=$(date +%Y)
    local days_in_year=365
    if (( (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0) )); then
        days_in_year=366
    fi
    local curr=$(( (doy - 1) * 86400 + $(date +%-k 2>/dev/null || date +%-H)*3600 + $(date +%-M)*60 + $(date +%-S) ))
    _tempo_draw "$curr" $((days_in_year * 86400)) "Year"
}

# Main command
tempo() {
    local items=$(_tempo_get_config TEMPO_SHOW_ITEMS "day week month year")
    
    if [[ $# -eq 0 ]]; then
        for item in ${=items}; do
            case $item in
                day|daily) _tempo_calc_day ;;
                week|weekly) _tempo_calc_week ;;
                month|monthly) _tempo_calc_month ;;
                year|yearly) _tempo_calc_year ;;
            esac
        done
        return
    fi

    case "$1" in
        -d|--day) _tempo_calc_day ;;
        -w|--week) _tempo_calc_week ;;
        -m|--month) _tempo_calc_month ;;
        -y|--year) _tempo_calc_year ;;
        -c|--config)
            echo "Tempo Configuration:"
            echo "  TEMPO_AUTO_SHOW   = $(_tempo_get_config TEMPO_AUTO_SHOW true)"
            echo "  TEMPO_WIDTH       = $(_tempo_get_config TEMPO_WIDTH 40)"
            echo "  TEMPO_SHOW_ITEMS  = $(_tempo_get_config TEMPO_SHOW_ITEMS 'day week month year')"
            echo "  TEMPO_FILLED_CHAR = $(_tempo_get_config TEMPO_FILLED_CHAR '█')"
            echo "  TEMPO_EMPTY_CHAR  = $(_tempo_get_config TEMPO_EMPTY_CHAR '░')"
            echo "  TEMPO_COLOR_STYLE = $(_tempo_get_config TEMPO_COLOR_STYLE true)"
            ;;
        -h|--help)
            echo "Usage: tempo [OPTION]"
            echo "Display time progress bars"
            echo ""
            echo "Options:"
            echo "  -d, --day      Show day progress"
            echo "  -w, --week     Show week progress"
            echo "  -m, --month    Show month progress"
            echo "  -y, --year     Show year progress"
            echo "  -c, --config   Show current configuration"
            echo "  -h, --help     Show this help messages"
            ;;
        *)
            echo "Unknown option: $1. Try 'tempo --help'."
            return 1
            ;;
    esac
}

# Zsh Completion
if [ "$(type -w compdef 2>/dev/null)" = "compdef: command" ]; then
    _tempo_completion() {
        local -a options
        options=(
            '(-d --day)'{-d,--day}'[Show day progress]'
            '(-w --week)'{-w,--week}'[Show week progress]'
            '(-m --month)'{-m,--month}'[Show month progress]'
            '(-y --year)'{-y,--year}'[Show year progress]'
            '(-c --config)'{-c,--config}'[Show current configuration]'
            '(-h --help)'{-h,--help}'[Show help message]'
        )
        _describe 'tempo' options
    }
    compdef _tempo_completion tempo
fi

# Startup Hook
_tempo_init() {
    if [[ "$(_tempo_get_config TEMPO_AUTO_SHOW true)" == "true" ]]; then
        tempo
    fi
    add-zsh-hook -d precmd _tempo_init
}

if [[ -t 1 ]]; then
    add-zsh-hook precmd _tempo_init
fi


