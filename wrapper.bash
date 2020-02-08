#!/bin/bash

set -e

gcloud config set project $PROJECT_ID

for zone in $(gcloud container clusters list --format="value(zone)"); do
  if [ $TEMPLATE_FILE ]; then
    if [ ! -f $TEMPLATE_FILE.bak ]; then
      cp $TEMPLATE_FILE $TEMPLATE_FILE.bak
    fi
    cat $TEMPLATE_FILE.bak | sed "s/{{ZONE}}/${zone}/g" > $TEMPLATE_FILE

    # For debugging
    # cat $TEMPLATE_FILE
  fi

  cluster="cluster-${zone}"
  echo "CLOUDSDK_COMPUTE_ZONE=$zone,CLOUDSDK_CONTAINER_CLUSTER=${cluster}"

  export CLOUDSDK_COMPUTE_ZONE=${zone}
  export CLOUDSDK_CONTAINER_CLUSTER=${cluster}
  exec /builder/kubectl.bash "$@"

done
