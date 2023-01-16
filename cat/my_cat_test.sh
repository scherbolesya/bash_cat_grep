#!/bin/bash
my_fun=./s21_cat
original=cat
log=log_cat.txt
history=test_history.txt
my_err=my_err.txt
cat_err=cat_err.txt
files="../common/some_text.txt ../common/check.txt ../common/chis.txt
        ../common/err.txt not_exists.txt ../common/numbers.txt
        ../common/pov.txt ../common/proba.txt ../common/text.txt"
nonprintfiles="../common/text5.txt ../common/text123.txt"
echo
if [ "$(uname)" == "Darwin" ]; then
echo -e TESTS FOR MAC
flags="-b -e -v -n -s -t"
flagslettersonly="b e v n s t"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
echo -e TESTS FOR LINUX
flags=" -e -v -E -s -t -T -E"
flagslettersonly="e v E s t T E"
long_flags="--number-nonblank  --number --squeeze-blank"
fi
echo FLAGS: $flags
echo
my_res=my_res.txt
cat_res=cat_res.txt
rm -f $log $history
errors=0
tests=0
RED='\033[0;91m'
NC='\033[0m'

# 0 flags 1 file
echo 0 flags and 1 file >> $history
for file in $files
do
    command="$file"
    $my_fun $command > $my_res 2> $my_err
    $original $command > $cat_res 2> $cat_err
    echo $my_fun $command >> $history
    diff=`diff my_res.txt cat_res.txt`
    # diff_err=`diff my_err.txt cat_err.txt`
    let "test+=1"
    if [[ $diff != "" || `test -f $my_err` != `test -f $grep_err` ]]; then
      echo $command >> $log
      echo $diff >> $log
      echo "" >> $log
      echo "" >> $log
      let "errors+=1"
    fi
done
echo -e TEST 0 flags and 1 file "done" with ${RED} $errors ${NC} errors, total $test tests
echo
echo >> $history
echo >> $history

# 0 flags 2 files
echo 0 flags and 1 file >> $history
for file1 in $files
do
  for file2 in $files
  do
    command="$file1 $file2"
    $my_fun $command > $my_res 2> $my_err
    $original $command > $cat_res 2> $cat_err
    echo $my_fun $command >> $history
    diff=`diff my_res.txt cat_res.txt`
    # diff_err=`diff my_err.txt cat_err.txt`
    let "test+=1"
    if [[ $diff != "" || `test -f $my_err` != `test -f $grep_err` ]]; then
      echo $my_fun $command >> $log
      echo $diff >> $log
      echo "" >> $log
      echo "" >> $log
      let "errors+=1"
      exit 1
    fi
    done
done
echo -e TEST 0 flags and 2 files "done" with ${RED} $errors ${NC} errors, total $test tests
echo
echo >> $history
echo >> $history



# 1 flag 1 file
echo  1 flag 1 file >> $history
for file1 in $files
do
  for flag1 in $flags
  do
    command="$flag1 $file1"
    $my_fun $command > $my_res 2> $my_err
    $original $command > $cat_res 2> $cat_err
    echo $my_fun $command >> $history
    diff=`diff my_res.txt cat_res.txt`
    #diff_err=`diff my_err.txt cat_err.txt`
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
echo -e TEST 1 flag 1 file "done" with ${RED} $errors ${NC} errors, total $test tests
echo
echo >> $history
echo >> $history


testname="2 flags 1 file"
echo  $testname >> $history
for file1 in $files
do
  for flag1 in $flags
  do
    for flag2 in $flags
    do
    command="$flag1 $flag2 $file1"
    $my_fun $command > $my_res 2> $my_err
    $original $command > $cat_res 2> $cat_err
    echo $my_fun $command >> $history
    diff=`diff my_res.txt cat_res.txt`
    #diff_err=`diff my_err.txt cat_err.txt`
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
echo -e TEST $testname "done" with ${RED} $errors ${NC} errors, total $test tests
echo
echo >> $history
echo >> $history




testname="2 flags 2 files"
echo  $testname >> $history
for file1 in $files
do
for file2 in $files
do
  for flag1 in $flags
  do
    for flag2 in $flags
    do
    command="$flag1 $flag2 $file1 $file2"
    $my_fun $command > $my_res 2> $my_err
    $original $command > $cat_res 2> $cat_err
    echo $my_fun $command >> $history
    diff=`diff my_res.txt cat_res.txt`
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
echo -e TEST $testname "done" with ${RED} $errors ${NC} errors, total $test tests
echo
echo >> $history
echo >> $history




testname="2 flags 3 files"
echo  $testname >> $history
for file1 in $files
do
for file2 in $files
do
  for flag1 in $flags
  do
    for flag2 in $flags
    do
    command="$flag1 $flag2 $file1 $file2 $file1"
    $my_fun $command > $my_res 2> $my_err
    $original $command > $cat_res 2> $cat_err
    echo $my_fun $command >> $history
    diff=`diff my_res.txt cat_res.txt`
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
echo -e TEST $testname "done" with ${RED} $errors ${NC} errors, total $test tests
echo
echo >> $history
echo >> $history





testname="2 flags (-v and some other) 1 file (with nonprint symbols)"
echo  $testname >> $history
for file1 in $nonprintfiles
do
  for flag1 in $flags
  do
    command="$flag1 -v $file1"
    $my_fun $command > $my_res 2> $my_err
    $original $command > $cat_res 2> $cat_err
    echo $my_fun $command >> $history
    diff=`diff my_res.txt cat_res.txt`
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
echo -e TEST $testname "done" with ${RED} $errors ${NC} errors, total $test tests
echo
echo >> $history
echo >> $history



testname="2 flags with one '-' (-vb) 1 file"
echo  $testname >> $history
for file1 in $files
do
  for flag1 in $flagslettersonly
  do
  for flag2 in $flagslettersonly
  do
    command="-$flag1$flag2 $file1"
    $my_fun $command > $my_res 2> $my_err
    $original $command > $cat_res 2> $cat_err
    echo $my_fun $command >> $history
    diff=`diff my_res.txt cat_res.txt`
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
echo -e TEST $testname "done" with ${RED} $errors ${NC} errors, total $test tests
echo
echo >> $history
echo >> $history





if [ "$(uname)" != "Darwin" ]; then
testname="1 GNU long flag 1 file"
echo  $testname >> $history
for file1 in $files
do
  for flag1 in $long_flags
  do
    command="$flag1 $file1"
    $my_fun $command > $my_res 2> $my_err
    $original $command > $cat_res 2> $cat_err
    echo $my_fun $command >> $history
    diff=`diff my_res.txt cat_res.txt`
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
echo -e TEST $testname "done" with ${RED} $errors ${NC} errors, total $test tests
echo
echo >> $history
echo >> $history
fi



echo -e ${RED}TOTALLY $errors  errors ${NC}
rm $my_res $cat_res $my_err $cat_err