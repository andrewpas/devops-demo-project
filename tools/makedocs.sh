#!/usr/bin/bash
cd ./../ansible ;
./../ansible/make-ansible-docs.sh &
 cd ./../terraform ;
 ./../terraform/make-terraform-docs.sh &
cd ./../tools ;
merge-markdown -m ./../docs/makedocs.yml
