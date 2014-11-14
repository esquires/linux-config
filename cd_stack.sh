#inspired by this post:
#http://aijazansari.com/2010/02/20/navigating-the-directory-stack-in-bash/
#
#this version adds
#   1) checking for valid cd entries
#   2) ensuring uniqueness
#   3) simpler interface (just cd and cd -p)
#
#it is intended to be aliased with
#
#alias cd='cd_stack'

export DIR_STACK_MAX_IDX=10
export DIR_STACK_IDX=-1
unset  DIR_STACK
export DIR_STACK

function cd_stack {

    #get the destination directory
    if [ $1 == '-p' ]; then

        #print out the stack and select one
        if (( DIR_STACK_IDX == -1 )); then
            echo "the cd stack is currently empty"
        else
            for ((i=0; i <= DIR_STACK_IDX; i++)); do
                echo $i:  ${DIR_STACK[$i]}
            done
            read -p "Enter selection [empty quits]: "

            DIR=${DIR_STACK[$REPLY]}

            #if nothing entered (or an invalid entry) then exit
            if [ -z $DIR ]; then
                echo "exiting without changing directories..."
                return
            fi
        fi

    elif [ $1 == '-' ]; then

        #go to previous directory
        DIR=$OLDPWD

    elif [ $1 ]; then

        #anything else is assumed to be a directory
        DIR=$(realpath "$1")

    else

        #no arguments, go to home directory
        DIR=$HOME

    fi

    #don't add to the stack if an invalid directory was entered
    if ! command cd $DIR; then
        return
    fi

    #loop over the stack, checking to see if the directory already exists in
    #the stack. if it is, put DIR at the top of the stack and move everything
    #else down
    for ((i=0; i <= DIR_STACK_IDX; i++)); do

        #if there is a match in the stac
        if [ ${DIR_STACK[$i]} = $DIR ]; then

            #move everything down the stack
            for ((j=i; j < $((DIR_STACK_IDX)); j++)); do
                DIR_STACK[$j]=${DIR_STACK[$(($j+1))]}
            done

            #set the top of the stack
            DIR_STACK[$DIR_STACK_IDX]=$DIR

            #exit
            return

        fi

    done

    #directory not found so add it to the stack

    if (( DIR_STACK_IDX == DIR_STACK_MAX_IDX )); then

        #reached limit of stack
        unset DIR_STACK[0]

        for ((i=0; i < DIR_STACK_IDX; i++)); do
            DIR_STACK[$i]=${DIR_STACK[$i+1]}
        done

    else

        #not reached limit of stack
        DIR_STACK_IDX=$((DIR_STACK_IDX+1))

    fi

    DIR_STACK[$DIR_STACK_IDX]=$DIR

}
