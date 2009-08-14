#!/bin/sh
function usage()
{
	echo $1: start_version [end_version]
}
if [ $# -lt 1 ]; then
	echo "Wrong parameters"
	usage $0
	exit 1
fi

cd ../..
DIFF_DIR=oah_update_diff 
if [ -d $DIFF_DIR ]; then
	rm -fr $DIFF_DIR
fi
mkdir $DIFF_DIR

i=0
for x in src/Makefile.sources src/Makefile.win32.features-h src/Makefile.win32
do
	i=`expr $i '+' 1`
	echo "processing $x ..."
	logfile="$DIFF_DIR/$i-`basename ${x}`.diff"
	git diff $1..$2 -- $x > $logfile
	size=`du $logfile|awk '{print $1}'`
	if test $size -eq 0; then
		echo "$logfile has 0 length"
		rm -f $logfile
	fi
done
