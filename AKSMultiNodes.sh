# Some commands to create and play with an Azure Kubernetes Service Cluster with multi node pools
# tested in may 2019 with Azure CLI version 2.0.64
# You need to be already logged in your Azure Subscription

# Pause
read -p " Note : you need to perform an az login before - To continue Press [Enter]"
read -p " This script will create an AKS cluster and it will destroy it at this end - To start Press [Enter]"

# Create a resource group in East US
az group create --name RG-AKS-MultiNodes --location eastus

# Pause
read -p "Press [Enter]"

# Create a basic single-node AKS cluster
az aks create \
    --resource-group RG-AKS-MultiNodes \
    --name AKS-Multi-Stan \
    --enable-vmss \
    --node-count 1 \
    --generate-ssh-keys \
    --kubernetes-version 1.12.6

# Pause
read -p "Press [Enter]"

# Add a node pool
# Node pool name : 12 characters max, should only contain alphanumeric characters,
# lowercase only
# Azure VM Families : https://docs.microsoft.com/en-gb/azure/virtual-machines/linux/sizes
az aks nodepool add \
    --resource-group RG-AKS-MultiNodes \
    --cluster-name AKS-Multi-Stan \
    --name nodepoolb \
    --node-count 2 \
    --node-vm-size Standard_B2s

# Pause
read -p "Press [Enter]"

# To see the status of your node pools
az aks nodepool list --resource-group RG-AKS-MultiNodes \
    --cluster-name AKS-Multi-Stan -o table

# Pause
read -p "Press [Enter]"

# Upgrade a node pool
az aks nodepool upgrade \
    --resource-group RG-AKS-MultiNodes \
    --cluster-name AKS-Multi-Stan \
    --name nodepoolb \
    --kubernetes-version 1.12.7 \
    --no-wait

# Pause
read -p "Press [Enter]"

# Scale a node pool
az aks nodepool scale \
    --resource-group RG-AKS-MultiNodes \
    --cluster-name AKS-Multi-Stan \
    --name nodepoolb \
    --node-count 3 \
    --no-wait

# Pause
read -p "Press [Enter]"

# To see the status of your node pools
az aks nodepool list --resource-group RG-AKS-MultiNodes \
    --cluster-name AKS-Multi-Stan -o table

# Pause
read -p "Press [Enter]"

# To see what upgrades are available for this cluster AKS
az aks get-upgrades --resource-group RG-AKS-MultiNodes \
     --name AKS-Multi-Stan --output table

# Pause
read -p "Press [Enter]"

# To upgrade the control plane 
az aks upgrade --resource-group RG-AKS-MultiNodes \
     --name AKS-Multi-Stan --kubernetes-version 1.13.5

# Pause
read -p "Press [Enter]"

# Delete a node pool
az aks nodepool delete -g RG-AKS-MultiNodes \
   --cluster-name AKS-Multi-Stan --name nodepoolb --no-wait

# Pause
read -p "Press [Enter]"

# Delete the resource group and the cluster AKS inside
az group delete --name RG-AKS-MultiNodes --yes --no-wait