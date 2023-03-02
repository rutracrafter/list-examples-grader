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

cat out.txt | grep -e "FAILURES"
if [[ $? -ne 0 ]]
then
    echo "Good job, you passed all the tests!"
else
    cat out.txt | grep -e "Tests run:" | cut -d\, -f1 > tests-ran.txt
    cat out.txt | grep -e "Tests run:" | cut -d\, -f2 > tests-failed.txt

    RAN=`cat tests-ran.txt | cut -d ' ' -f3`
    FAILED=`cat tests-failed.txt | cut -d ' ' -f4`

    echo "Your grade is: " "$RAN"/"$(($RAN + $FAILED))"
    cat out.txt
fi