#/usr/bin/env bash

function _complete_bv_maker_()
{
    local word=${COMP_WORDS[COMP_CWORD]}
    local line=${COMP_LINE}
    local cmd_list="info sources configure build doc testref test pack install_pack testref_pack test_pack publish_pack"
    local opt_list="-c -h -d -s -b --username -e --email --disable-jenkins --def --only-if-default -v --verbose --version"

    COMPREPLY=($(compgen -W "$cmd_list $opt_list" -- "${word}"))
    if [ -n "$COMPREPLY" ]; then
        COMPREPLY="$COMPREPLY "
    fi

#     case "$COMP_CWORD" in
#     1)
#         COMPREPLY=($(compgen -W "$cmd_list $opt_list" -- "${word}"))
#         ;;
#     *)
#         local cmd=${COMP_WORDS[1]}
#
#         case "$cmd" in
#         info)
#             ;;
#         sources)
#             ;;
#         configure)
#             ;;
#         build)
#             ;;
#         doc)
#             ;;
#         testref)
#             ;;
#         test)
#             ;;
#         pack)
#             ;;
#         install_pack)
#             ;;
#         testref_pack)
#             ;;
#         test_pack)
#             ;;
#         publish_pack)
#             ;;
#         esac
#     esac

#     if [ -z "$COMPREPLY" ]; then
#         COMPREPLY=($(compgen -f -- "${word}"))
#     fi
}


function _complete_bv_env_()
{
    # exec bv_env and retreive PATH variable so that we can delegate completion
    # using the _command() bash completion function, within the correct path

    local _x=$(${COMP_WORDS[0]} | fgrep 'export PATH=')
    PATH="${_x:13:-1}" _command
}


# complete -W "info sources configure build doc testref test pack install_pack testref_pack test_pack publish_pack -c -h -d -s -b --username -e --email --disable-jenkins --def --only-if-default -v --verbose --version" bv_maker

complete -F _complete_bv_maker_ -o default -o nospace bv_maker
complete -F _complete_bv_env_ bv_env
