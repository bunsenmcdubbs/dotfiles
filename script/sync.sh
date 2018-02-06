#! /bin/sh

verbose=

case "$1" in
    -v|--v|--ve|--ver|--verb|--verbo|--verbos|--verbose)
        verbose=1
        shift ;;
esac


# write out to 3 for non-important stdout
# write out to 4 for non-important stderr
# 3 and 4 are quiet when `-v[e[r[b[o[s[e]]]]]]` is not present in invocation
if [ "$verbose" = 1 ]
then
    exec 4>&2 3>&1
else
    exec 4>/dev/null 3>/dev/null
fi

# verbose stdout
log_info() {
    (>&3 echo "$@")
}

# verbose stderr
log_err() {
    (>&4 echo "$@")
}

set -eu

symlink_ext=".symlink"
files=$(find . -type f -iname "*$symlink_ext")

failed_links=
success_links=

log_info "Linking dotfiles...\n"

for src_path in $files
do

    src_path=$(echo $src_path | tail -c +3)

    if [ $(dirname $src_path) != "." ]
    then
        rel_dir=$(dirname $src_path)/
    else
        rel_dir=""
    fi

    src=$(pwd)/$src_path
    dest=$HOME/$rel_dir$(basename $src_path $symlink_ext)

    if [[ -L $dest ]] || [[ -e $dest ]]
    then
        if [[ -L $dest ]] && [[ "$(readlink $dest)" -ef $src ]]
        then
            log_info "$dest already symlinked to $src_path"
        else
            log_err "Error! $dest already exists (and is not a symlink to $src_path). Skipped."
            failed_links="$dest\n$failed_links"
        fi
    else
        log_info "Symlinking $dest to $src_path"
        if ln -s $src $dest
        then
            success_links="$dest\n$success_links"
        else
            log_err "Symlink failed!"
            failed_links="$dest\n$failed_links"
        fi
    fi

done

log_info "\nFinished processing dotfiles."

if [ "$success_links" != "" ]
then
    log_info "\nSuccessfully linked:\n$success_links"
fi

if [ "$failed_links" != "" ]
then
    # always write these failures to stdout
    (>&2 echo "Failed to link:\n$failed_links")
    exit 1
fi
