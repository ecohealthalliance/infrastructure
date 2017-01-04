SourceSHA=$(curl -s $1)
TargetSHA=$(curl -s $2)
SourceLength=${#SourceSHA}
if [ ${#SourceSHA} -ne 40 ] || [ ${#TargetSHA} -ne 40 ] || [ $SourceSHA != $TargetSHA ]; then
  exit 1
else
  echo 0
fi
