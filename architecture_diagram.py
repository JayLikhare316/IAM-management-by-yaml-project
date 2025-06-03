#!/usr/bin/env python3
from diagrams import Diagram, Cluster
from diagrams.aws.security import IAM, IAMPermissions
from diagrams.aws.management import Config
from diagrams.onprem.iac import Terraform
from diagrams.onprem.client import User

with Diagram("IAM Management by YAML Architecture", show=True, direction="LR"):
    
    with Cluster("Configuration"):
        yaml_config = Config("users.yaml")
        terraform = Terraform("Terraform")
    
    with Cluster("AWS IAM Resources"):
        with Cluster("IAM Users"):
            users = IAM("IAM Users")
        
        with Cluster("IAM Groups"):
            groups = IAM("IAM Groups")
            
        with Cluster("IAM Policies"):
            policies = IAMPermissions("IAM Policies")
    
    # Flow
    yaml_config >> terraform
    terraform >> users
    terraform >> groups
    terraform >> policies
    
    # Relationships
    users >> groups
    users >> policies
