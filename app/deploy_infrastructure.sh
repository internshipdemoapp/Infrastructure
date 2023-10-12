#!/bin/bash

terraform init
terraform plan -out=infrastructure.tf.plan
terraform apply -auto-approve infrastructure.tf.plan
rm -rf infrastructure.tf.plan