# Deployment

- Clone this repository in the local machine:

  - git clone 

  - and change into the newly created directory:

  - cd ccslurm4ai

- Edit the input.yaml file with the required and optional parameters you collect in the checklist.xlsx 
- Edit the settings.yaml file to select which azure resources you want to deployed 

- Execute the install script:

```bash

sudo chmod -R -f 777 /tf/avm/scripts
sudo chmod -R -f 777 /tf/avm/gcc_starter_kit/landingzone/configuration

# 0-1-2: 0-launchpad, landing zone and solution accelerator
cd /tf/avm/scripts

./install.sh
```

  - If ran without options, the install script will first perform the infrastructure deployment through terraform using aks archetype by default.



