#!/bin/bash
cd /repo/$USER/ebb
clear

while [[ $# -gt 0 ]]
do
  case $1 in
    -a|--author)
    AUTHOR+=("$2")
    shift # past argument
    shift # past value
    ;;
    -s|--since)
    DATE="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    echo -e "\033[0;31munknown option:\033[0m $1"
    shift # past argument
    ;;
  esac
done

if [ "$DATE" == "" ]; then
  echo -e "\033[1;31m!!!\tWARNING \t!!!\033[0m"
  echo 'non specific date'
  echo -e 'set date to 01.07.2018\n'
  DATE="01.07.2018"
fi
echo -e "results from date $DATE\n"

declare -A commitsMergedA
declare -A filesChangedA
declare -A insertionsA
declare -A deletionsA

bestWorkerFunction()
{
  var=$(declare -p "$1")
  eval "declare -A _arr="${var#*=}
  for k in "${!_arr[@]}"; do
    echo "$k: ${_arr[$k]}"
  done |
  sort -k2,2rn -k1,1
}

for currentAuthor in "${AUTHOR[@]}"; 
do 
  gitLogResult=$(git log --author=$currentAuthor --oneline --since="$DATE" --no-decorate --shortstat | awk 'NR%2==0')
  cd /repo/$USER/config
  gitLogResult2=$(git log --author=$currentAuthor --oneline --since="$DATE" --no-decorate --shortstat | awk 'NR%2==0')
  gitLogResult=$(echo -e "$gitLogResult\n$gitLogResult2")
  cd /repo/$USER/ebb

  if [ "$gitLogResult" == "" ]; then
    commitsMerged=0
  else  
    commitsMerged=$(echo "$gitLogResult" | wc -l)
  fi

  filesChanged=$(echo "$gitLogResult" | awk '{split($0,a,",");sum+=a[1]}END{print sum+0}')
  insertions=$(echo "$gitLogResult" | awk '{split($0,a,",");sum+=a[2]}END{print sum+0}')
  deletions=$(echo "$gitLogResult" | awk '{split($0,a,",");sum+=a[3]}END{print sum+0}')
  echo -e "\033[1m$currentAuthor\033[0m commits merged: $commitsMerged"; 
  echo -e "\033[1m$currentAuthor\033[0m files changed: $filesChanged"; 
  echo -e "\033[1m$currentAuthor\033[0m insertions(+): $insertions"; 
  echo -e "\033[1m$currentAuthor\033[0m deletions(-): $deletions";

  commitsMergedA["$currentAuthor"]="$commitsMerged"
  filesChangedA["$currentAuthor"]="$filesChanged"
  insertionsA["$currentAuthor"]="$insertions"
  deletionsA["$currentAuthor"]="$deletions"
done

echo -e "\033[1mMost commits was merged by \033[0m" ; bestWorkerFunction "commitsMergedA" ; echo 
echo -e "\033[1mMost files was changed by \033[0m"  ; bestWorkerFunction "filesChangedA" ; echo
echo -e "\033[1mMost insertions was made by \033[0m"; bestWorkerFunction "insertionsA" ; echo
echo -e "\033[1mMost deletions was made by \033[0m" ; bestWorkerFunction "deletionsA" ; echo
