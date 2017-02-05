#!/bin/sh

_check_cmd () {

    command -v $1 >/dev/null 2>&1 && echo "1";
    
}

_init () {

    CONF_SCRIPT_DIR=".pushall.sh";

    if [ ! "$XDG_CONFIG_HOME" ]; then
	XDG_CONFIG_HOME=~/.config;
    fi

    if [ ! "$XDG_DATA_HOME" ]; then
        XDG_DATA_HOME=~/.local/share;
    fi
    
    if [ $(_check_cmd printf) ]; then
	PRINT="printf %s\n";
	PRINT_E="printf %b\n";
	PRINT_N="printf %s";
	PRINT_EN="printf %b";
    elif [ $(_check_cmd echo) ]; then
	PRINT="echo";
	PRINT_E="echo -e";
	PRINT_N="echo -n";
	PRINT_EN="echo -en";
    else
	exit 1;
    fi

    # TODO: Implement more robust checking for https/SSL in install
    if [ ! $(_check_cmd curl) ]; then
	_print_err "No curl is found!"
	exit 1;
    fi
    
}

_print () {

    if [ ! "$PRINT" ] || [ ! "$PRINT_E" ] || [ ! "$PRINT_N" ] || [ ! "$PRINT_EN" ]; then
	exit 1;
    fi

    if [ ! "$2" ]; then
	PRINT_ARG=$1;
    else
	PRINT_MOD=$1;
	PRINT_ARG=$2;
    fi

    case $PRINT_MOD in
	-e)
	    $PRINT_E "$PRINT_ARG"
	;;
	-n)
	    $PRINT_N "$PRINT_ARG"
	;;
	-en|-ne)
	    $PRINT_EN "$PRINT_ARG"
	;;
	*)
	    $PRINT "$PRINT_ARG"
	;;
    esac

}

_print_err () {
    _print "$@" >&2
}

_usage () {

    _print "Usage: $0 [-ctTh] [COMMAND]"
    _print
    _print "API calls to pushall.ru"
    _print "v 0.0.1"
    _print
    _print "COMMAND can be:"
    _print -e "\t\tsend or empty - send specified API call"
    _print
    _print "General options:"
    _print -e "\t-c\tAPI call"
    _print -e "\t-h\tThis usage help"
    _print
    _print "Options for self API:"
    _print -e "\t-t\tPush message title"
    _print -e "\t-T\tPush message text"
    _print -e "\t-i\tPush message icon"
    _print -e "\t-u\tPush message URL"
    _print -e "\t-u\tHide option for push message"
    _print -e "\t-e\tPush message encoding"
    _print -e "\t-p\tPush message priority"
    _print -e "\t-l\tPush message TTL"
    _print

}

_parse_options () {

    if [ "$1" = "" ]; then
	_usage
	exit 0;
    fi

    while getopts "hH:c:t:T:i:u:e:p:l:" opt
    do
	case "$opt" in
	    h)
		_usage
		exit 0;
	    ;;
	    c)
		PUSHALL_API=$OPTARG;
	    ;;
	    t)
		TITLE="$OPTARG";
	    ;;
	    T)
		TEXT="$OPTARG";
	    ;;
	    i)
		ICON="$OPTARG";
	    ;;
	    u)
		URL="$OPTARG";
	    ;;
	    H)
		HIDDEN="$OPTARG";
	    ;;
	    e)
		ENCODE="$OPTARG";
	    ;;
	    p)
		PRIORITY="$OPTARG";
	    ;;
	    l)
		TTL="$OPTARG";
	    ;;
	esac
    done
    
}


#TITLE;
#TEXT;
#ICON;
#URL;
#HIDDEN;
#ENCODE;
#PRIORITY;
#TTL;

_self_api_call () {

    if [ ! "$TITLE" ]; then
	_print_err "Title (-t) is required for self API call"
	exit 1;
    fi
    if [ ! "$TEXT" ]; then
	_print_err "Text (-T) is required for self API call"
	exit 1;
    fi
    _print_err "Not implemented!"

}

_init
_parse_options "$@"
shift $((OPTIND-1));
COMMAND=$1;

case "$COMMAND" in

    [Ss][Ee][Nn][Dd]|"")
	case "$PUSHALL_API" in
	    [Ss][Ee][Ll][Ff])
		_self_api_call
	    ;;
	    *)
		_print_err "Unknown API: \"$PUSHALL_API\""
		exit 1;
	    ;;
	esac
    ;;
    *)
	_print_err "Unknown command: \"$COMMAND\""
    ;;

esac
