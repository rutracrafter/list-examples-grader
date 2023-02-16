CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'

cd student-submission

if [[ -f "ListExamples.java" ]]
then
	echo "ListExamples.java found!"
else
	echo "ListExamples.java not found!"
	exit 1
fi

mkdir lib
cp ../lib/hamcrest-core-1.3.jar ./lib
cp ../lib/junit-4.13.2.jar ./lib
cp ../TestListExamples.java ./

set -e
javac ListExamples.java
if [[ $? -ne 0 ]]
then
	echo "ListExamples.java compilation failed!"
fi

javac -cp $CPATH TestListExamples.java >out.txt 2>&1
if [[ $? -ne 0 ]]
then
	echo "Test file compilation failed!"
	exit 1
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples >out.txt 2>&1

LINE_NO=2

i=0
#for line in out.txt
#do
#	(( i+=1 ))
#	if [[ $i -eq 2 ]]
#	then
#		echo $line
#	fi
#done

sed -n 2p out.txt

