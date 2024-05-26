#!/bin/bash

# Apply Terraform configurations and check if it was successful
terraform apply --auto-approve
if [ $? -eq 0 ]; then
    echo "Terraform apply completed successfully."
    gcloud auth activate-service-account --key-file=/Users/sbezanovic/Downloads/gd-gcp-gridu-devops-t1-t2-706da06965a4.json
    # Proceed with getting credentials and applying Kubernetes configurations
    gcloud container clusters get-credentials sbezanovic-cluster-np --region us-central1 --project gd-gcp-gridu-devops-t1-t2
    kubectl apply -f sock-shop.yaml
else
    echo "Terraform apply failed."
    # Handle the error case here, perhaps with a retry or exit
    exit 1
fi
