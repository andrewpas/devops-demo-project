#!/usr/bin/env bash
project_dir="../src"
for i in $(ls $project_dir )
do
  cd ../templates
  jinja2-render "$i" -c ./ci-env.py  -f ./ci-template.yaml.j2 -o ../ci/ci_"$i".yml
done
