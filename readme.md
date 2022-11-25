Assumption :
Company Name: chirag
VPN: chiragvpn


This Repo has the terrafoprm code to dropbox , which could be used within the chirag network and to upload anything to any s3 bucket within bizops account.

- create new dropbox on s3 bucket for internal use within chirag
- dropbox will be accessible within the chiragvpn
- lifecycle of the objects in the dropbox will be in number of days specified in expiration(defaults to 30) 
- onboard new product on the dropbox creating a dedicated folder for product
- creating policy to access (list and upload) the product folder
- creting role for the products
- attach respective policies to the role being created
- create users for product 
- map the respective product policies to the user 


Note: Any additional permission to the product user or role can be done granted from console, cli or other terraform code, This code won't remove the additional policy attached to the role or user.

Template for the env_name.tfvars file :

region="<aws_region>"
aws_profile="<aws_profile>"
account_id="<aws_account_id>"
environment_name="<env_name:qa/stage/prod>"
system_name="<bucket_name>"
expiration=10<specify_days ex: 10>
product_names=["<product1>", "<product2>"]