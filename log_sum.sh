flag=""
len=0

argHandler() {
    while getopts "L:c2rFt" arg; do
        case $arg in
            L) 
                if [ $OPTARG -le 0 ]; then
                    echo "ERROR !! -L must be a positive int"
                    exit 0
                fi
                len=$OPTARG ;;

            c|2|r|F|t)
                flag="-$arg"
                echo "chosen flag is $flag";;

            \?)
                echo "ERROR !! Usage: log_sum.sh [−L N] (−c|−2|−r|−F|−t) <filename>"
                exit 0;;

        esac
    done
}

cHandler() {
    declare -A ipHits=()
    while read -r ip; do
        ((ipHits["$ip"]++))
    done < <(awk '{print $1}' $4)

    for ip in "${!ipHits[@]}"; do
        echo "${ipHits[$ip]} $ip"
    done | sort -nr | head -n "$len" | while read -r hits ip; do
        echo "$ip   $hits"
    done

}


twoHandler() {
    awk '{print $9}' $4
}

rHandler() {
    echo "NAY"
}

fHandler() {
    echo "NAY"
}

tHandler() {
    echo "NAY"
}

main() {

    argHandler "$@"
    if [ "$flag" = "-c" ]; then
        cHandler "$@"
    elif [ "$flag" = "-2" ]; then
        twoHandler "$@"
    fi
}

main "$@"
