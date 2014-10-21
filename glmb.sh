#!/bin/bash
#
# PURPOSE 
#
#   while git log commit1...commit2 does the same thing, it does not implement --graph 
#
# USAGE 
#
#   usage: glmb [git log options] [--format=0] sha1 sha2 [sha3 ...]
#
#   --format=0: print the default git log format (otherwise, one line per commit)
#

#check for appropriate number of arguments
if [[ $# -le 1 ]]; then 
    echo "usage: glmb [git log options] [--format=1] sha1 sha2 [sha3 ...]" >&2
    exit 1
fi

#process command line arguments
if [[ $1 == '-h' || $1 == '--help' ]]; then 
    echo "usage: glmb [git log options] [--format=1] sha1 sha2 [sha3 ...]" 
    exit 0
fi

format_output=1
finished=false

while [[ -n $1 ]]; do 

    tmp=$1

    if [ ${tmp:0:9} == '--format=' ]; then 
        format_output=${tmp:9:1}
    elif [ ${tmp:0:1} == '-' ]; then 
        finished=true
        usr_options="$usr_options $1"
    else 
        branches="$branches $1"
    fi

    shift

done

merge_base="$(git merge-base $branches )"
for b in $branches; do 
    lines_bw_commits=$(git rev-list --count --left-right $b...$merge_base | cut -f 1 )
    tot_lines_needed=$(( tot_lines_needed + lines_bw_commits ))
done
tot_lines_needed=$(( tot_lines_needed+1 ))

if (( format_output == 1 )); then 
    git log --pretty=format:'%C(yellow)%h %ad %Creset%s %C(red)%d %Cgreen[%cn] %Creset' --decorate --date=short --graph -$tot_lines_needed $usr_options $branches ^$merge_base~
else
    git log -$tot_lines_needed $usr_options $branches ^$merge_base~
fi
