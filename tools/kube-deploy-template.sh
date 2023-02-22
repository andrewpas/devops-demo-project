#!/usr/bin/env bash
project_dir="../src"
for i in $(ls $project_dir )
do
  cd ../templates
  jinja2-render "$i" -c ./debpoy-"$1"-env.py  -f ./deploy-template.yaml.j2 -o ../kubernetes/"$i"-"$1"-deployment.yaml

  jinja2-render "$i" -c ./debpoy-"$1"-env.py  -f ./service-template.yaml.j2 -o ../kubernetes/"$i"-"$1"-service.yaml
done
