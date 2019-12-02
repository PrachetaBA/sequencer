#! /bin/bash

echo "npr-predict.sh start"

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT_DIR="$(dirname "$CURRENT_DIR")"

HELP_MESSAGE=$'Usage: ./npr-predict.sh --buggy_file=[abs path] --buggy_line=[int] --beam_size=[int] --output=[abs path]
buggy_file: Absolute path to the buggy file
buggy_line: Line number of buggy line
beam_size: Beam size used in seq2seq model
output: Absolute path for output'
for i in "$@"
do
case $i in
    --buggy_file=*)
    BUGGY_FILE_PATH="${i#*=}"
    shift # past argument=value
    ;;
    --buggy_line=*)
    BUGGY_LINE="${i#*=}"
    shift # past argument=value
    ;;
    --beam_size=*)
    BEAM_SIZE="${i#*=}"
    shift # past argument=value
    ;;
    --output=*)
    OUTPUT="${i#*=}"
    shift # past argument=value
    ;;
    *)
          # unknown option
    ;;
esac
done

if [ -z "$BUGGY_FILE_PATH" ]; then
  echo "BUGGY_FILE_PATH unset!"
  echo "$HELP_MESSAGE"
  exit 1
elif [[ "$BUGGY_FILE_PATH" != /* ]]; then
  echo "BUGGY_FILE_PATH must be absolute path"
  echo "$HELP_MESSAGE"
  exit 1
fi

if [ -z "$BUGGY_LINE" ]; then
  echo "BUGGY_LINE unset!"
  echo "$HELP_MESSAGE"
  exit 1
fi

if [ -z "$BEAM_SIZE" ]; then
  echo "BEAM_SIZE unset!"
  echo "$HELP_MESSAGE"
  exit 1
fi

if [ -z "$OUTPUT" ]; then
  echo "OUTPUT unset!"
  echo "$HELP_MESSAGE"
  exit 1
elif [[ "$OUTPUT" != /* ]]; then
  echo "OUTPUT must be absolute path"
  echo "$HELP_MESSAGE"
  exit 1
fi

echo "Input parameter:"
echo "BUGGY_FILE_PATH = ${BUGGY_FILE_PATH}"
echo "BUGGY_LINE = ${BUGGY_LINE}"
echo "BEAM_SIZE = ${BEAM_SIZE}"
echo "OUTPUT = ${OUTPUT}"
echo

BUGGY_FILE_NAME=${BUGGY_FILE_PATH##*/}
BUGGY_FILE_BASENAME=${BUGGY_FILE_NAME%.*}

echo "Creating temporary working folder"
tmp=`basename $OUTPUT`
#tmp="$(cut -d'/' -f10 <<<"$OUTPUT")"
mkdir -p $CURRENT_DIR/NPR_Experiment/tmp_folders/${tmp}
echo "Creating tmp directory $CURRENT_DIR/${tmp}"
echo

echo "Abstracting the source file"
# the code of abstraction-1.0-SNAPSHOT-jar-with-dependencies.jar is in https://github.com/KTH/sequencer/tree/master/src/Buggy_Context_Abstraction/abstraction
java -jar $CURRENT_DIR/lib/abstraction-1.0-SNAPSHOT-jar-with-dependencies.jar $BUGGY_FILE_PATH $BUGGY_LINE $CURRENT_DIR/NPR_Experiment/tmp_folders/${tmp}
retval=$?
if [ $retval -ne 0 ]; then
  echo "Cannot generate abstraction for the buggy file"
  rm -rf $CURRENT_DIR/NPR_Experiment/tmp_folders/${tmp}
  exit 1
fi
echo

echo "Tokenizing the abstraction"
python3 $CURRENT_DIR/Buggy_Context_Abstraction/tokenize.py $CURRENT_DIR/NPR_Experiment/tmp_folders/${tmp}/${BUGGY_FILE_BASENAME}_abstract.java $CURRENT_DIR/NPR_Experiment/tmp_folders/${tmp}/${BUGGY_FILE_BASENAME}_abstract_tokenized.txt
retval=$?
if [ $retval -ne 0 ]; then
  echo "Tokenization failed"
  rm -rf $CURRENT_DIR/NPR_Experiment/tmp_folders/${tmp}
  exit 1
fi
echo

#echo "Truncate the abstraction to 1000 tokens"
#perl $CURRENT_DIR/Buggy_Context_Abstraction/trimCon.pl $CURRENT_DIR/NPR_Experiment/tmp_folders/${tmp}/${BUGGY_FILE_BASENAME}_abstract_tokenized.txt $CURRENT_DIR/NPR_Experiment/tmp_folders/${tmp}/${BUGGY_FILE_BASENAME}_abstract_tokenized_truncated.txt 1000
retval=$?
#if [ $retval -ne 0 ]; then
#	echo "Truncation failed"
# 	rm -rf $CURRENT_DIR/NPR_Experiment/tmp_folders/${tmp}
# 	exit 1
#fi
#echo

echo "Creating output directory ${OUTPUT}"
if [ -d $OUTPUT ]; then
    rm -rf $OUTPUT
fi
mkdir -p $OUTPUT
echo

echo "Generating predictions"
python3 $CURRENT_DIR/lib/OpenNMT-py/translate.py -model $ROOT_DIR/model/npr_model.pt -src $CURRENT_DIR/NPR_Experiment/tmp_folders/${tmp}/${BUGGY_FILE_BASENAME}_abstract_tokenized.txt -output $OUTPUT/predictions.txt -beam_size $BEAM_SIZE -n_best $BEAM_SIZE 1>/dev/null
echo

echo "Checking accuracy of predictions"
python3 $CURRENT_DIR/NPR_Experiment/check_accuracy.py ${tmp} $BEAM_SIZE $OUTPUT/predictions.txt > $OUTPUT/${tmp}.txt
echo 
exit 0
