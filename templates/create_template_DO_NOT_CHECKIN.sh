cd /tf/avm/templates
find . -name '*.tf' -exec sed -i -e 's/aoaidev-rg-launchpad/{{resource_group_name}}/g' {} \;
find . -name '*.tf' -exec sed -i -e 's/aoaidevstgtfstatepcz/{{storage_account_name}}/g' {} \;
# find . -name 'import.sh' -exec sed -i -e 's/xxxxxxxxxx-0ad7-4552-936f-xxxxxxxxxxxx/{{subscription_id}}/g' {} \;
# find . -name '*.tfvars' -exec sed -i -e 's/aoaidev/{{prefix}}/g' {} \;
# find . -name '*.tfvars' -exec sed -i -e 's/southeastasia/{{location}}/g' {} \;
find . -name '*.md' -exec sed -i -e 's/aoaidev-rg-launchpad/{{resource_group_name}}/g' {} \;
find . -name '*.md' -exec sed -i -e 's/aoaidevstgtfstatepcz/{{storage_account_name}}/g' {} \;

cd /tf/avm/templates/landingzone/configuration/0-launchpad
find . -name '*.md' -exec sed -i -e 's/gcc_starter_kit/{{gcc_starter_kit}}/g' {} \;

cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators
find . -name '*.md' -exec sed -i -e 's/gcc_starter_kit/{{gcc_starter_kit}}/g' {} \;


# the other way 
find . -name '*.md' -exec sed -i -e 's/{{resource_group_name}}/aoaidev-rg-launchpad/g' {} \;
find . -name '*.md' -exec sed -i -e 's/{{storage_account_name}}/aoaidevstgtfstatepcz/g' {} \;


