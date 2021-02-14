#Terraform demo on splitting and joining terraform projects/repos
_(Note, you will need terraform 0.12.0 or higher and a free AWS account. I've tried to use free-tier eligible AWS resources but you may incur some costs depending on how long you leave the resources up)_
------------------------------------------------------------------

##Initial Setup
1. Clone down this repository! 
2. Navigate to the root of this project (terraform-demo) and run `terraform init`
3. In S3, check for a bucket called 'terraform-demo-reorganizing-repos' and navigate inside to see the initial statefile has been created
4. Review the terraform project in its existing state with three modules in three directories (budget, messaging-application, and web-application)
5. Run a `terraform plan` and then `terraform apply` to bring up the resources
	`terraform state list` should show resources from all three modules

##Splitting the Repository
_(Main objective: Copy the entire project and then remove the components we no longer need)_
6. Navigate to the directory holding the cloned terraform-demo project and run `cp -r terraform-demo terraform-web-application`
7. Remove the budet and messagingg application resources files and module references
	- Delete messaging-application and budget module blocks from main.t
	- Delete the messaging-application and budget directories
8. Update the backend stanza in terraform.tf with "demo-web-application" as the new s3 key
9. terraform init (use the default option to start with existing state)
10. Run terraform plan and notice that terraform proposes to destroy all of the module.budget and module.messaging-application resources because they still exist in the statefile but not in the project
11. Run ./tf-state-rm-cleanup-exclude.sh - the script will prompt you for the name of the module you wish to keep reference to (web-application). The script will run terraform state rm <resource> on all resources except those belonging to module.web-application
12. Run terraform plan and see that terraform now proposes no changes
13. Perform parallel steps in the terraform-demo project
	- Delete web-application module block from main.tf
	- Delete the web-application directory
14. Also need to cleanup the old terraform-demo statefile. Use tf-state-rm-cleanup.sh (different script) which prompt you for the name of the one module you wish to remove from the statefile (web-application)
15. Run terraform apply and notice that no changes are proposed

##Joining the Repositories
_(Main objective: Move web-application resources files back to terraform-demo and then use terraform state mv to move information from the terraform-web-application statefile created in the previous steps back to the demo-starting-key statefile)_
16. Copy web-application directory back into terraform-demo using the command line or your IDE
17. Add web-application module block back to main.tf (source should be ./web-application)
18. Run `terraform plan | grep created` and notice that terraform wants to now create all the module.web-application resources because the terraform statefile used by terraform-demo no longer has any reference to these resources vecause of Step 14 above
19. Navigate to the root of terraform-demo and run the script tf-copy-resources-from-old-statefile.sh. It will prompt you for the relative path of the project to copy resources from (../terraform-web-application) and the name of the module that holds the resources to copy (module.web-application)
    - This script downloads the "old" (demo-web-application) and destination (demo-starting-key) statefiles from s3 and then uses the `terraform state mv` command to copy resources into the destination statefile. It also re-uploads the updated statefile to the s3 backend
20. Run terraform plan one more time. Terraform should propose no changes. Terraform state list should show resources for all three module (budget, messsaging-application, and web-application)
