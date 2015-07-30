#!/bin/sh

tmpdir=
cleanup() {
    rm -rf "$tmpdir"
}
trap cleanup EXIT HUP INT QUIT TERM
tmpdir=$(mktemp -d)

verbose=true

test_autodetection() {
    printf '%s... ' "$*"

    # The path to bv_env.sh is quoted
    cat <<EOF >| "$tmpdir"/test.sh
. $BV_ENV_DOTSCRIPT
printf '%s' "\$BRAINVISA_SHARE" >| "$tmpdir"/test_output
exit
EOF

    if ! type "$1" > /dev/null 2>&1; then
        echo "skipped (shell not found)."
        return 0
    fi
    run_test "$@"
    test_result
}

test_parameter() {
    printf '%s... ' "$*"

    cat <<EOF >| "$tmpdir/test.sh"
. "$BV_ENV_DOTSCRIPT" "$BV_DIR"
printf '%s' "\$BRAINVISA_SHARE" >| "$tmpdir"/test_output
exit
EOF

    if ! type "$1" > /dev/null 2>&1; then
        echo "skipped (shell not found)."
        return 0
    fi
    run_test "$@"
    test_result
}

test_path() {
    printf '%s... ' "$*"

    cat <<EOF >| "$tmpdir/test.sh"
PATH="$BV_DIR/bin:\$PATH"
. "$BV_ENV_DOTSCRIPT"
printf '%s' "\$BRAINVISA_SHARE" >| "$tmpdir"/test_output
exit
EOF

    if ! type "$1" > /dev/null 2>&1; then
        echo "skipped (shell not found)."
        return 0
    fi
    run_test "$@"
    test_result
}

run_test() {
    # Empty the test output file
    : >| "$tmpdir"/test_output

    env -i PATH="$PATH" "$@" < "$tmpdir/test.sh" >| "$tmpdir/shell_out" 2>| "$tmpdir/shell_err"
}

test_result() {
    if cmp "$tmpdir"/expected_output "$tmpdir"/test_output > /dev/null 2>&1; then
        num_passed=$(($num_passed + 1))
        echo "passed."
        return 0
    else
        echo "FAILED."
        if $verbose; then
            printf '%s' "===== BRAINVISA_SHARE value: "
            cat "$tmpdir"/test_output
            printf '\n'
            echo "===== Test script:"
            cat "$tmpdir"/test.sh
            echo "===== Standard output:"
            cat "$tmpdir"/shell_out
            echo "===== Standard error:"
            cat "$tmpdir"/shell_err
            echo "====="
        fi
        num_failed=$(($num_failed + 1))
        return 1
    fi
}

if [ $# -ne 1 ]; then
    echo "Usage: $0 /path/to/brainvisa" >&2
    exit 2
fi

BV_DIR=$1
BV_ENV_DOTSCRIPT=$BV_DIR/bin/bv_env.sh

num_failed=0

printf '%s/share' "$BV_DIR" > "$tmpdir"/expected_output

echo "Testing passing of PATH to bv_env directory:"
test_path /bin/bash --noprofile --norc
test_path /bin/bash --noprofile --norc -e
test_path /bin/bash --noprofile --norc --posix
test_path /bin/bash --noprofile --norc --posix -e
test_path /bin/dash
test_path /bin/dash -e
test_path /bin/zsh
test_path /bin/zsh -e
echo

echo "Testing passing of the bv_env directory as argument:"
test_parameter /bin/bash --noprofile --norc
test_parameter /bin/bash --noprofile --norc -e
test_parameter /bin/bash --noprofile --norc --posix
test_parameter /bin/bash --noprofile --norc --posix -e
#test_parameter /bin/dash  # Does not work with this minimalistic shell
test_parameter /bin/zsh
test_parameter /bin/zsh -e
echo

echo "Testing auto-detection of directory in pseudo-interactive shell:"
test_autodetection /bin/bash --noprofile --norc -i
test_autodetection /bin/bash --noprofile --norc --posix -i
#test_autodetection /bin/dash -i  # Does not work with this minimalistic shell
test_autodetection /bin/zsh

if [ $num_failed -eq 0 ]; then
    echo "No test failed :-)"
    exit 0
else
    echo "$num_failed/$(($num_passed + $num_failed)) tests failed :-("
    exit 1
fi
