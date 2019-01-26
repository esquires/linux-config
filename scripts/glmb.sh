#!/bin/bash
#
# PURPOSE
#
#   while git log commit1...commit2 does the same thing, it does not implement --graph
#
# USAGE
#
#   usage: glmb [git log options] [--format=1] sha1 [sha2=HEAD sha3 ...]
#
#   --format=0: print the default git log format (otherwise, one line per commit)
#

#process command line arguments
if [[ $1 == '-h' || $1 == '--help' ]]; then
    echo "usage: glmb [git log options] [--format=1] sha1 [sha2=HEAD sha3 ...]"
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

# make HEAD default
num_branches=$(echo $branches | wc -w)
if [[ $num_branches -eq 0 ]]; then
    echo 'hi'
    echo "usage: glmb [git log options] [--format=1] sha1 [sha2=HEAD sha3 ...]" >&2
    exit 1
elif [[ $num_branches -eq 1 ]]; then
    branches="$branches HEAD"
fi

#get the merge base.
merge_base="$(git merge-base $branches)"

if git cat-file -t $merge_base~ > /dev/null 2>&1; then

    #^ - exclude
    #~ - parent
    #^$merge_base~ - exclude everything before the merge base
    mb_arg="^$merge_base~"

else

    #if the parent of the merge base does not exist, then one of the input
    #sha's is the first commit so there is no need to bother with a merge base
    #see here:
    #http://stackoverflow.com/questions/18515488/how-to-check-if-the-commit-exists-in-a-git-repository-by-its-sha-1
    mb_arg=""

fi

if (( format_output == 1 )); then
    git log --pretty=format:'%C(yellow)%h %ad %Creset%s %C(red)%d %Cgreen[%cn] %Creset' --decorate --date=short --graph $usr_options $branches $mb_arg
else
    git log -$tot_lines_needed $usr_options $branches $mb_arg
fi
