# Apply simple transformations and bring data to BigQuery as cost-efficient as possible
ELT is a relatively new concept. Cheap availability of Data Warehouses allows efficient on-demand transformations. That saves storage and increases flexibility. All you have to manage are queries, not transformed datasets. And you can always go back to data in it's raw form.

Although, sometimes it just makes sense to apply transformation on incoming data directly. 
What if we need to apply some general cleaning, or would like to apply machine learning inference on the incoming data at the soonest point possible?

Traditional [ETL](https://cloud.google.com/bigquery/docs/migration/pipelines#etl) is a proven concept to do just that.

But ETL tools are maintenance overhead. In our example, you don't want to manage a Spark, GKE cluster or similar.Specifically, your requirement is a serverless and elastic ETL pipeline.

That means your pipeline should scale down to 0 when unused or up to whatever is needed to cope with a higher load.

## STEP 1

First component of our lightweight ETL pipeline is a BigQuery Table named `cloud_run`.
The BigQuery Table should make use of the schema file `./schema.json`.
The processing service will stream the transformed data into this table.

Run this command

```
bq mk --location=europe-west1 --table $GCP_PROJECT:data_journey.cloud run ./schema.json
```

OR follow the documentation on how to [create a BigQuery table with schema through the console](https://cloud.google.com/bigquery/docs/tables#console).

</details>

## STEP 2
Second, let's set up your Cloud Run Processing Service. `./ETL/Cloud Run` contains all the necessary files.

Inspect the `Dockerfile` to understand how the container will be build.

`main.py` defines the web server that handles the incoming data points. Inspect `main.py` to understand the web server logic.
As you can see `main.py` is missing two code snippets.

Complete the web server with the BigQuery client and Client API call to insert rows to BigQuery from a json object.
Use the BigQuery Python SDK.

Before you start coding replace the required variables in `config.py` so you can access them safely in `main.py`.

Define the [BigQuery Python Client](https://cloud.google.com/python/docs/reference/bigquery/latest/google.cloud.bigquery.client.Client#google_cloud_bigquery_client_Client_insert_rows_json) as followed:
```
client = bigquery.Client(project=config.project_id, location=config.location)
```

Insert rows form JSON via [the Client's insert_rows_json method](https://cloud.google.com/python/docs/reference/bigquery/latest/google.cloud.bigquery.client.Client#google_cloud_bigquery_client_Client_insert_rows_json):
```
errors = client.insert_rows_json(table_id, rows_to_insert)  # Make an API request.
```

</details>

Once the code is completed build the container from `./ETL/Cloud Run` into a new [Container Repository] (ttps://cloud.google.com/artifact-registry/docs/overview) named `data-processing-service`.

```
cd ..
```

```
gcloud builds submit $RUN_PROCESSING_DIR --tag gcr.io/$GCP_PROJECT/data-processing-service
```

Validate the successful build with:

```
gcloud container images list
```

You should see something like:
```
NAME: gcr.io/<project-id>/pubsub-proxy
NAME: gcr.io/<project-id>/data-processing-service
Only listing images in gcr.io/<project-id>. Use --repository to list images in other repositories.
```

</details>

## STEP 3

As you did before, deploy a new cloud run processing service based on the container you just build to your Container Registry.

```
gcloud run deploy dj-run-service-data-processing --image gcr.io/$GCP_PROJECT/data-processing-service:latest --region=europe-west1 --allow-unauthenticated
```

</details>


## Challenge 3.5
Define a Pub/Sub subscription named `dj-subscription_cloud_run` that can forward incoming messages to an endpoint.

You will need to create a Push Subscription to the Pub/Sub topic we already defined.


Enter the displayed URL of your processing in `./config_env.sh` as `PUSH_ENDPOINT` & reset the environment variables.

```
source config_env.sh
```

Create PubSub push subscription: 
```
gcloud pubsub subscriptions create dj-subscription_cloud_run \
    --topic=dj-pubsub-topic \
    --push-endpoint=$PUSH_ENDPOINT
```

OR 

read it can be [defined via the console](https://cloud.google.com/pubsub/docs/create-subscription#pubsub_create_push_subscription-console).

</details>


## Validate lightweight ETL pipeline implementation

You can now stream website interaction data points through your Cloud Run Proxy Service, Pub/Sub Topic & Subscription, Cloud Run Processing and all the way up to your BigQuery destination table.

Run 

```
python3 ./datalayer/synth_data_stream.py --endpoint=$ENDPOINT_URL
```

to direct an artificial click stream at your pipeline. No need to reinitialize if you still have the clickstream running from earlier.

After a minute or two you should find your BigQuery destination table populated with data points. 
The metrics of Pub/Sub topic and Subscription should also show the throughput.
Take a specific look at the un-acknowledged message metrics in Pub/Sub.
If everything works as expected it should be 0.
