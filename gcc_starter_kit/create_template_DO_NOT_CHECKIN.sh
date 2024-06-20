cd /tf/avm/gcc_starter_kit
find . -name '*.tf' -exec sed -i -e 's/aoaiuat-rg-launchpad/{{resource_group_name}}/g' {} \;
find . -name '*.tf' -exec sed -i -e 's/aoaiuatstgtfstatenoi/{{storage_account_name}}/g' {} \;
find . -name '*.md' -exec sed -i -e 's/aoaiuat-rg-launchpad/{{resource_group_name}}/g' {} \;
find . -name '*.md' -exec sed -i -e 's/aoaiuatstgtfstatenoi/{{storage_account_name}}/g' {} \;

# cd /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad
# find . -name '*.md' -exec sed -i -e 's/gcc_starter_kit/gcc_starter_kit/g' {} \;

# cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators
# find . -name '*.md' -exec sed -i -e 's/gcc_starter_kit/gcc_starter_kit/g' {} \;


# the other way 
# find . -name '*.md' -exec sed -i -e 's/{{resource_group_name}}/aoaidev-rg-launchpad/g' {} \;
# find . -name '*.md' -exec sed -i -e 's/{{storage_account_name}}/aoaidevstgtfstatepcz/g' {} \;


