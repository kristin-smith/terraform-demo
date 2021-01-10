#~ /bin/bash
echo "Enter the relative path of the terraform project to copy resources from (source):"
read source
while [ ! -d $source ]; do
  echo "Opps! Directory ${source} does not exist. Enter a valid relative path of the terraform project to copy resources from (source):"
  read source
done

echo "Enter the relative path of the terraform project to copy resources into (destination):"
read destination
while [ ! -d $destination ]; do
  echo "Opps! Directory ${destination} does not exist. Enter a valid relative path of the terraform project to copy resources into (destination):"
  read source
done
startpoint=$(pwd)

modulesContainsModule () {
  contains=""
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && contains="yes" && return 0; done
  return 1
}

findUniqueModulesInOldProject () {
  modules=()
  cat ${destination}/${sourceKey} | grep '"module":' | awk '{print $2}' | sed 's/"//g; s/,//g'> modules-to-copy.txt
  while read m; do
    modulesContainsModule $m "${modules[@]}"
    if [[ $contains == "" ]]; then
        modules+=( $m )
        echo $m
    fi
  done < modules-to-copy.txt
}

cd $source
sourceBucket=$(grep "bucket" terraform.tf | awk '{print $3}' | sed 's/"//g')
sourceKey=$(grep "key" terraform.tf | awk '{print $3}' | sed 's/"//g')
aws s3 cp s3://${sourceBucket}/${sourceKey}  ${startpoint}/${destination}/${sourceKey}
cd $startpoint/${destination}
findUniqueModulesInOldProject

echo "Enter which module you want to copy to the current state file:"
read copyModule
destBucket=$(grep "bucket" terraform.tf | awk '{print $3}' | sed 's/"//g')
destKey=$(grep "key" terraform.tf | awk '{print $3}' | sed 's/"//g')
aws s3 cp s3://${destBucket}/${destKey} ${destKey}
echo "This is the planned destination S3 location for the combined statefile: s3://${destBucket}/${destKey}"
echo "Enter yes to continue:"
read validateCopy
if [[ ! $validateCopy = "yes" ]];
  then
    echo "Copy cancelled, ending script now"
    exit
  else
    echo "proceeding with copy"
    terraform state mv -state=${sourceKey} --state-out=${destKey} ${copyModule} ${copyModule}
    cat ${destKey}
fi
aws s3 cp ${destKey} s3://${destBucket}/${destKey}
