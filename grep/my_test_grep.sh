#!/bin/bash
my_fun=./s21_grep
original=grep
patterns="This is a text 5 Click this Num 1-9"
log=log_grep.txt
history=test_history.txt
files="../common/some_text.txt ../common/check.txt ../common/chis.txt ../common/err.txt not_exists.txt ../common/numbers.txt ../common/pov.txt ../common/proba.txt ../common/text.txt Makefile"
pattern_files="../common/pattern1.txt ../common/pattern3.txt ../common/pattern2.txt"
flags="-e -i -v -c -l -n -h -s"
my_log=my_res.txt
grep_log=grep_res.txt
my_err=my_err.txt
grep_err=grep_err.txt
rm -f $log $history
errors=0
tests=0
RED='\033[0;91m'
NC='\033[0m'

# no flags and 1 file
echo no flags and 1 file >> $history
for file in $files
do
  echo "$test of 90 tests done"
  for pattern in $patterns
  do
    command="$my_fun $pattern $file"
    $command > $my_log 2>$my_err
    $original $pattern $file > $grep_log 2> $grep_err
    echo  $command >> $history
    diff=`diff -a my_res.txt grep_res.txt`
    let "test+=1"
    if [[ $diff != "" || `test -f $my_err` != `test -f $grep_err` ]]; then
      echo $command >> $log
      echo $diff >> $log
      echo "" >> $log
      echo "" >> $log
      let "errors+=1"
    fi
  done
done
echo
echo -e TEST 0 flags and 1 file "done" with ${RED}$errors${NC} errors
echo
echo >> $history
echo >> $history

# One Flag One File Test
echo 1 flag and 1 file >> $history
for file in $files
do
  echo "$test of 738 tests done"
  for pattern in $patterns
  do
    for flag in $flags
    do
      command="$my_fun $flag $pattern $file "
      $command > $my_log 2>$my_err
      # $my_fun $flag $pattern $file > $my_log
      $original $flag $pattern $file > $grep_log 2> $grep_err
      echo $command >> $history
      diff=`diff my_res.txt grep_res.txt`
      let "test+=1"
      if [[ $diff != "" || `test -f $my_err` != `test -f $grep_err` ]]; then
        echo $command >> $log
        echo $diff >> $log
        echo "" >> $log
        echo "" >> $log
        let "errors+=1"
      fi
      done
  done
done
echo
echo -e TEST 1 flag and 1 file "done" with ${RED}$errors${NC} errors
echo
echo >> $history
echo >> $history


# One Flag Two Files Test
echo 1 Flag 2 Files Test >> $history
for file1 in $files
do
echo "$test of 7290 tests done"
  for pattern in $patterns
  do
    for flag in $flags
    do
    for file2 in $files
      do
        command="$my_fun $flag $pattern $file1 $file2"
        echo $command >> $history
        $command > $my_log 2>$my_err
        # $my_fun $flag $pattern $file1 $file2 > $my_log
        $original $flag $pattern $file1 $file2 > $grep_log 2>$grep_err
        diff=`diff my_res.txt grep_res.txt`
        let "test+=1"
        if [[ $diff != "" || `test -f $my_err` != `test -f $grep_err` ]]; then
          echo $command >> $log
          echo $diff >> $log
          echo "" >> $log
          echo "" >> $log
          let "errors+=1"
        fi
        done
      done
  done
done
echo
echo -e TEST 1 flag and 2 files "done" with ${RED}$errors${NC} errors
echo
echo >> $history
echo >> $history



# Two Flags One Files (Two for '-e' flag) Test
echo "2 Flags 1 Files (Two for '-e' flag) Test" >> $history
for file1 in $files
do
echo "$test of 13194 tests done"
  for pattern2 in $patterns
  do
    for flag1 in $flags
    do
    for flag2 in $flags
      do
        if [ "$(uname)" == "Darwin" ]; then
        command="$flag1 $pattern1 $flag2 $pattern2 $file1"
        else
        command="-e $pattern1 $flag2 $pattern2 $file1"
        fi
        echo $my_fun $command >> $history
        $my_fun $command > $my_log 2>$my_err
        # $my_fun $flag $pattern $file1 $file2 > $my_log
        $original $command > $grep_log 2> $grep_err
        diff=`diff my_res.txt grep_res.txt`
        let "test+=1"
        if [[ $diff != "" || `test -f $my_err` != `test -f $grep_err` ]]; then
          echo $my_fun $command >> $log
          echo $diff >> $log
          echo "" >> $log
          echo "" >> $log
          let "errors+=1"
        fi
        done
      done
  done
done
echo
echo -e TEST "2 flags and 1 file (Two for '-e' flag) Test" "done" with ${RED}$errors${NC} errors
echo
echo >> $history
echo >> $history
# rm $my_log $grep_log


# Two Flags One Files (Test for '-f') Test
echo "Two Flags One Files (Test for '-f') Test" >> $history
for file1 in $files
do
echo "$test of 13986 tests done"
  for pattern1 in $pattern_files
  do
    for flag2 in $flags
      do
        command="-f $pattern1 $flag2 $pattern2 $file1"
        echo $my_fun $command >> $history
        $my_fun $command > $my_log 2>$my_err
        # $my_fun $flag $pattern $file1 $file2 > $my_log
        $original $command > $grep_log 2>$grep_err
        diff=`diff my_res.txt grep_res.txt`
        let "test+=1"
        if [[ $diff != "" || `test -f $my_err` != `test -f $grep_err` ]]; then
          echo $my_fun $command >> $log
          echo $diff >> $log
          echo "" >> $log
          echo "" >> $log
          let "errors+=1"
        fi
      done
  done
done
echo
echo -e TEST "2 flags 1 files (Test for '-f') Test" "done" with ${RED}$errors${NC} errors
echo
echo >> $history
echo >> $history
echo -e ${RED}TOTALLY $errors errors ${NC}
rm $my_log $grep_log $my_err $grep_err