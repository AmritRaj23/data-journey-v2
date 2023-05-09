#!/bin/sh

export GCP_PROJECT="default-project-id"
export ENDPOINT_URL="<add here" # doesn't need to be defined in the very beginning
export PUSH_ENDPOINT="<add here>" # doesn't need to be defined in the very beginning
export GCP_REGION="europe-west1"
export RUN_PROXY_DIR=cloud-run-pubsub-proxy
export RUN_PROCESSING_DIR=cloudrun
#export DATAFLOW_TEMPLATE=dataflow

export BUCKET=example-bucket-name-$GCP_PROJECT
export FILE=sample_events.json
