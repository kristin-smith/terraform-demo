#!/bin/bash

##List out the known modules based on the current statefile
terraform state list | awk -F "." '{print $2}'> state-list.txt
echo "These are the current modules in the project"
modules=()
while read m; do
  if [[ ! " ${modules[@]} " =~ " ${m} " ]]; then
      modules+=( $m )
      echo $m
  fi
done < state-list.txt

##Object: given a module or list of modules by the user, remove all of that module's resources from the terraform state
