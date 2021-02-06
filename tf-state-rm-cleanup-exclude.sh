#!/bin/bash
##Object: given a module or list of modules by the user, remove all resources from the terraform state except for that module's resources

cleanup () {
  [[ -f module-list.txt ]] && rm module-list.txt
  [[ -f non-modularized-resources.txt ]] && rm non-modularized-resources.txt
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

removeResourcesNotInModule () {
  while read r; do
    if [[ $(echo $r | grep module.$module | wc -l) -eq 0 ]]; then
        terraform state rm $r
    fi
  done < state-list.txt
  echo "these are the modules remaining:"
  terraform state list | grep module | awk -F "." '{print $2}'
}

cleanup
echo "Searching for current project modules"
terraform state list > state-list.txt
while read resource; do
  if [[ $(echo $resource | grep module | wc -l) -gt 0 ]]; then
      echo $resource | awk -F "." '{print $2}' >> module-list.txt
      else
        echo "  " $resource >> non-modularized-resources.txt
  fi
done < state-list.txt

echo "These are the current modules in the project"
modules=()

findUniqueModules
echo "Which module would you like to keep?"
read module
modulesContainsModule $module "${modules[@]}"
while [[ $contains == "" ]]; do
    echo "$module not a valid module, please try again:"
    read module
    modulesContainsModule $module "${modules[@]}"
done

echo "You'd like to keep module.${module}. Enter yes/no to continue:"
read validateModule
if [[ ! $validateModule = "yes" ]];
    then
      echo "Module not confirmed, ending script now"
      exit
    else
      echo "Will remove all resources from the Terraform state file except for resources belonging to module.${module} including the follow non-modularized resources."
      cat non-modularized-resources.txt
      echo "Enter Y to proceed:"
      read validateRemoval
      if [[ ! $validateRemoval == "Y" ]];
        then
          echo "Removal cancelled, ending script now"
          cleanup
          exit
        else
          removeResourcesNotInModule $module
          cleanup
      fi
fi
