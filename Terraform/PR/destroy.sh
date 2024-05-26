#!/bin/bash
terraform destroy --auto-approve
sleep 400s
kubectl delete -f sock-shop.yaml
