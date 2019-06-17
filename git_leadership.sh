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

mostCommitsMergedCount=0
mostFilesChangedCount=0
mostInsertionsCount=0
mostDeletionsCount=0

secondCommitsMergedCount=0
secondFilesChangedCount=0
secondInsertionsCount=0
secondDeletionsCount=0

thirdCommitsMergedCount=0
thirdFilesChangedCount=0
thirdInsertionsCount=0
thirdDeletionsCount=0

fourthCommitsMergedCount=0
fourthFilesChangedCount=0
fourthInsertionsCount=0
fourthDeletionsCount=0

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
  echo

  if [ $commitsMerged -gt 0 ]; then
    if [ $commitsMerged -gt $mostCommitsMergedCount ]; then
      fourthCommitsMergedCount=$thirdCommitsMergedCount
      fourthCommitsMergedAuthor=$thirdCommitsMergedAuthor
      thirdCommitsMergedCount=$secondCommitsMergedCount
      thirdCommitsMergedAuthor=$secondCommitsMergedAuthor
      secondCommitsMergedCount=$mostCommitsMergedCount
      secondCommitsMergedAuthor=$mostCommitsMergedAuthor
      mostCommitsMergedAuthor=$currentAuthor
      mostCommitsMergedCount=$commitsMerged
    elif [ $commitsMerged -gt $secondCommitsMergedCount ]; then
      fourthCommitsMergedCount=$thirdCommitsMergedCount
      fourthCommitsMergedAuthor=$thirdCommitsMergedAuthor
      thirdCommitsMergedCount=$secondCommitsMergedCount
      thirdCommitsMergedAuthor=$secondCommitsMergedAuthor
      secondCommitsMergedCount=$commitsMerged
      secondCommitsMergedAuthor=$currentAuthor
    elif [ $commitsMerged -gt $thirdCommitsMergedCount ]; then
      fourthCommitsMergedCount=$thirdCommitsMergedCount
      fourthCommitsMergedAuthor=$thirdCommitsMergedAuthor
      thirdCommitsMergedCount=$commitsMerged
      thirdCommitsMergedAuthor=$currentAuthor
    elif [ $commitsMerged -gt $fourthCommitsMergedCount ]; then
      fourthCommitsMergedCount=$commitsMerged
      fourthCommitsMergedAuthor=$currentAuthor
    fi

    if [ $filesChanged -gt $mostFilesChangedCount ]; then
      fourthFilesChangedAuthor=$thirdFilesChangedAuthor
      fourthFilesChangedCount=$thirdFilesChangedCount
      thirdFilesChangedAuthor=$secondFilesChangedAuthor
      thirdFilesChangedCount=$secondFilesChangedCount
      secondFilesChangedAuthor=$mostFilesChangedAuthor
      secondFilesChangedCount=$mostFilesChangedCount
      mostFilesChangedAuthor=$currentAuthor
      mostFilesChangedCount=$filesChanged
    elif [ $filesChanged -gt $secondFilesChangedCount ]; then
      fourthFilesChangedAuthor=$thirdFilesChangedAuthor
      fourthFilesChangedCount=$thirdFilesChangedCount
      thirdFilesChangedAuthor=$secondFilesChangedAuthor
      thirdFilesChangedCount=$secondFilesChangedCount
      secondFilesChangedAuthor=$currentAuthor
      secondFilesChangedCount=$filesChanged
    elif [ $filesChanged -gt $thirdFilesChangedCount ]; then
      fourthFilesChangedAuthor=$thirdFilesChangedAuthor
      fourthFilesChangedCount=$thirdFilesChangedCount
      thirdFilesChangedAuthor=$currentAuthor
      thirdFilesChangedCount=$filesChanged
    elif [ $filesChanged -gt $fourthFilesChangedCount ]; then
      fourthFilesChangedAuthor=$currentAuthor
      fourthFilesChangedCount=$filesChanged
    fi

    if [ $insertions -gt $mostInsertionsCount ]; then
      fourthInsertionsAuthor=$thirdInsertionsAuthor
      fourthInsertionsCount=$thirdInsertionsCount
      thirdInsertionsAuthor=$secondInsertionsAuthor
      thirdInsertionsCount=$secondInsertionsCount
      secondInsertionsAuthor=$mostInsertionsAuthor
      secondInsertionsCount=$mostInsertionsCount
      mostInsertionsAuthor=$currentAuthor
      mostInsertionsCount=$insertions
    elif [ $insertions -gt $secondInsertionsCount ]; then
      fourthInsertionsAuthor=$thirdInsertionsAuthor
      fourthInsertionsCount=$thirdInsertionsCount
      thirdInsertionsAuthor=$secondInsertionsAuthor
      thirdInsertionsCount=$secondInsertionsCount
      secondInsertionsAuthor=$currentAuthor
      secondInsertionsCount=$insertions
    elif [ $insertions -gt $thirdInsertionsCount ]; then
      fourthInsertionsAuthor=$thirdInsertionsAuthor
      fourthInsertionsCount=$thirdInsertionsCount
      thirdInsertionsAuthor=$currentAuthor
      thirdInsertionsCount=$insertions
    elif [ $insertions -gt $fourthInsertionsCount ]; then
      fourthInsertionsAuthor=$currentAuthor
      fourthInsertionsCount=$insertions
    fi

    if [ $deletions -gt $mostDeletionsCount ]; then
      fourthDeletionsAuthor=$thirdDeletionsAuthor
      fourthDeletionsCount=$thirdDeletionsCount
      thirdDeletionsAuthor=$secondDeletionsAuthor
      thirdDeletionsCount=$secondDeletionsCount
      secondDeletionsAuthor=$mostDeletionsAuthor
      secondDeletionsCount=$mostDeletionsCount
      mostDeletionsAuthor=$currentAuthor
      mostDeletionsCount=$deletions
    elif [ $deletions -gt $secondDeletionsCount ]; then
      fourthDeletionsAuthor=$thirdDeletionsAuthor
      fourthDeletionsCount=$thirdDeletionsCount
      thirdDeletionsAuthor=$secondDeletionsAuthor
      thirdDeletionsCount=$secondDeletionsCount
      secondDeletionsAuthor=$currentAuthor
      secondDeletionsCount=$deletions
    elif [ $deletions -gt $thirdDeletionsCount ]; then
      fourthDeletionsAuthor=$thirdDeletionsAuthor
      fourthDeletionsCount=$thirdDeletionsCount
      thirdDeletionsAuthor=$currentAuthor
      thirdDeletionsCount=$deletions
    elif [ $deletions -gt $thirdDeletionsCount ]; then
      fourthDeletionsAuthor=$currentAuthor
      fourthDeletionsCount=$deletions
    fi
  fi
done

echo "most commits was merged by   $mostCommitsMergedAuthor $mostCommitsMergedCount"
echo "most files was changed by    $mostFilesChangedAuthor $mostFilesChangedCount"
echo "most insertion was marged by $mostInsertionsAuthor $mostInsertionsCount"
echo "most deletions was marged by $mostDeletionsAuthor $mostDeletionsCount"
echo
echo "second commits was merged by   $secondCommitsMergedAuthor $secondCommitsMergedCount"
echo "second files was changed by    $secondFilesChangedAuthor $secondFilesChangedCount"
echo "second insertion was marged by $secondInsertionsAuthor $secondInsertionsCount"
echo "second deletions was marged by $secondDeletionsAuthor $secondDeletionsCount"
echo
echo "third commits was merged by   $thirdCommitsMergedAuthor $thirdCommitsMergedCount"
echo "third files was changed by    $thirdFilesChangedAuthor $thirdFilesChangedCount"
echo "third insertion was marged by $thirdInsertionsAuthor $thirdInsertionsCount"
echo "third deletions was marged by $thirdDeletionsAuthor $thirdDeletionsCount"
echo
echo "fourth commits was merged by   $fourthCommitsMergedAuthor $fourthCommitsMergedCount"
echo "fourth files was changed by    $fourthFilesChangedAuthor $fourthFilesChangedCount"
echo "fourth insertion was marged by $fourthInsertionsAuthor $fourthInsertionsCount"
echo "fourth deletions was marged by $fourthDeletionsAuthor $fourthDeletionsCount"

