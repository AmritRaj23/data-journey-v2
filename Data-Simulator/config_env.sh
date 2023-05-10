#!/bin/sh

export GCP_PROJECT="<PROJECT-ID>"
export ENDPOINT_URL="<ENDPOINT URL>" # doesn't need to be defined in the very beginning
export GCP_REGION="<REGION>"
export DATAFLOW_TEMPLATE=dataflow
export RUN_PROXY_DIR=cloud-run-pubsub-proxy
# export RUN_PROCESSING_DIR=processing-service     # only needed for /ETL/CloudRun
# export PUSH_ENDPOINT='<processing-endpoint-url>' # only needed for /ETL/CloudRun

export BUCKET=example-bucket-name-$GCP_PROJECT
export FILE=sample_events.json
