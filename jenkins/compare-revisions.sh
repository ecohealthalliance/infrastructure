SourceSHA=$(curl -s $1)
TargetSHA=$(curl -s $2)
SourceLength=${#SourceSHA}
if [ ${#SourceSHA} -ne 40 ] || [ ${#TargetSHA} -ne 40 ]; then
  echo 'Invalid SHA, do not update.'
  exit 1
elif [ $SourceSHA != $TargetSHA ]; then
  echo 'Update'
  exit 0
else
  echo 'Do not update'
  exit 1
fi