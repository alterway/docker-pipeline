#!/usr/bin/env bash
#
# This script is used to define useful functions to write messages with easy coloration.
# Use this script as a callee of "autoload.sh" of the pipeline.
#

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[30m'        # Black
Red='\033[31m'          # Red
Green='\033[32m'        # Green
Yellow='\033[33m'       # Yellow
Blue='\033[34m'         # Blue
Purple='\033[35m'       # Purple
Cyan='\033[36m'         # Cyan
White='\033[37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[90m'       # Black
IRed='\033[91m'         # Red
IGreen='\033[92m'       # Green
IYellow='\033[93m'      # Yellow
IBlue='\033[94m'        # Blue
IPurple='\033[95m'      # Purple
ICyan='\033[96m'        # Cyan
IWhite='\033[97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[100m'   # Black
On_IRed='\033[101m'     # Red
On_IGreen='\033[102m'   # Green
On_IYellow='\033[103m'  # Yellow
On_IBlue='\033[104m'    # Blue
On_IPurple='\033[105m'  # Purple
On_ICyan='\033[106m'    # Cyan
On_IWhite='\033[107m'   # White

write() {
    # Keep the status and shift to keep only all messages as arguments.
    status="${1:-}"
    shift

    case "${status}" in
        "error") colorCode=${Red}
        ;;
        "warning") colorCode=${Yellow}
        ;;
        "success") colorCode=${Green}
        ;;
        "info") colorCode=${Cyan}
        ;;
        "summary") colorCode=${Purple}
        ;;
        *|"default") colorCode=${White}
        ;;
    esac

    for msg in "$@"
    do
        echo -e "${colorCode}${msg}${Color_Off}"
    done
}

write_block() {
    # Keep the status and shift to keep only all messages as arguments.
    status="${1:-}"
    shift

    allLinesOfMessage=()
    longestLineInMessage=0
    if [[ ! -z $TERM ]] && [[ 'dumb' != $TERM ]]; then
        maximumLineLengthToDisplay=$((`tput cols` - 16))
    else
        maximumLineLengthToDisplay=120
    fi
    for msg in "$@"
    do
        msg="${msg#"${msg%%[![:space:]]*}"}" # remove leading whitespace characters
        msg="${msg%"${msg##*[![:space:]]}"}" # remove trailing whitespace characters

        #If, after trimming, the message is empty, do not add it in the list of messages to display, so continue.
        if [[ -z ${msg} ]]; then
            continue
        fi

        foldedMsgLine=$(fold -sw ${maximumLineLengthToDisplay} <<< "${msg}")
        allLinesOfMessage+=("${foldedMsgLine}")

        currentLineLength=${#msg}
        if [[ ${currentLineLength} -gt ${maximumLineLengthToDisplay} ]]; then
            currentLineLength=${maximumLineLengthToDisplay}
        fi
        if [[ ${longestLineInMessage} -lt ${currentLineLength} ]]; then
            longestLineInMessage=${currentLineLength}
        fi
    done

    # If no more message to display, get out.
    if [ ${#allLinesOfMessage[@]} -eq 0 ]; then
        return 0
    fi

    case "${status}" in
        "error") colorCode=${On_Red}${BWhite}
        ;;
        "warning") colorCode=${On_Yellow}${BBlack}
        ;;
        "success") colorCode=${On_Green}${BBlack}
        ;;
        "info") colorCode=${On_Blue}${BWhite}
        ;;
        "summary") colorCode=${On_Purple}${BWhite}
        ;;
        "reversed") colorCode=${On_White}${BBlack}
        ;;
        *|"default") colorCode=${Color_Off}
        ;;
    esac

    block_length=$(( ${longestLineInMessage} + 8 ))
    border=`printf %${block_length}s`

    echo -e "${Color_Off}    ${colorCode}${border}${Color_Off}"
    for msg in "${allLinesOfMessage[@]}"
    do
        trailing_spaces_number=$(( 4 + ${longestLineInMessage} - ${#msg} ))
        trailing_spaces="$(printf %${trailing_spaces_number}s)"
        echo -e "${Color_Off}    ${colorCode}    ${msg}${trailing_spaces}${Color_Off}"
    done
    echo -e "${Color_Off}    ${colorCode}${border}${Color_Off}"
}

write_error_block() { write_block "error" "$@"; }
write_warning_block() { write_block "warning" "$@"; }
write_success_block() { write_block "success" "$@"; }
write_info_block() { write_block "info" "$@"; }
write_summary_block() { write_block "summary" "$@"; }
write_reversed_block() { write_block "reversed" "$@"; }
write_default_block() { write_block "default" "$@"; }

write_error() { write "error" "$@"; }
write_warning() { write "warning" "$@"; }
write_success() { write "success" "$@"; }
write_info() { write "info" "$@"; }
write_summary() { write "summary" "$@"; }
write_default() { write "default" "$@"; }

