#!/bin/bash
##Object: given a module or list of modules by the user, remove all resources from the terraform state except for that module's resources

cleanup () {
  [[ -f module-list.txt ]] && rm module-list.txt
  [[ -f state-list.txt ]] && rm state-list.txt
}

modulesContainsModule () {
  contains=""
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && contains="yes" && return 0; done
  return 1
}

findUniqueModules () {
  while read m; do
    modulesContainsModule $m "${modules[@]}"
    if [[ $contains == "" ]]; then
        modules+=( $m )
        echo $m
    fi
  done < module-list.txt
}

removeResourcesInModule () {
  while read r; do
    if [[ $(echo $r | grep module.$module | wc -l) -eq 1 ]]; then
        terraform state rm $r
    fi
  done < state-list.txt
  echo "these are the resources remaining:"
  terraform state list
}

cleanup
echo "Searching for current project modules"
terraform state list > state-list.txt
cat state-list.txt | grep  module | awk -F "." '{print $2}'> module-list.txt
echo "These are the current modules in the project"

modules=()

findUniqueModules
echo "Which module would you like to remove from this statefile? (Resources will persist in AWS)"
read module
modulesContainsModule $module "${modules[@]}"
while [[ $contains == "" ]]; do
    echo "$module not a valid module, please try again:"
    read module
    modulesContainsModule $module "${modules[@]}"
done

echo "You'd like to remove module.${module} from this state file. Enter yes/no to continue:"
read validateModule
if [[ ! $validateModule == "yes" ]];
    then
      echo "Module not confirmed, ending script now"
      exit
    else
      echo "Will remove all resources from the Terraform state file belonging to module.${module}. Enter Y to proceed:"
      read validateRemoval
      if [[ ! $validateRemoval == "Y" ]];
        then
          echo "Removal cancelled, ending script now"
          cleanup
          exit
        else
          removeResourcesInModule $module
          cleanup
      fi
fi
