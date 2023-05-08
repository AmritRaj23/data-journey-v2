# Data Ingestion

You are an e-commerce start-up. Your web-shop app is the heart of your business.

Your company decided to improve engagement and drive up revenue through data-driven insights.

You already have google tag manager set up for activity tracking. Great! Only the data pipeline is missing.

As Data Engineer you want to set up a solution to collect and analyze user interactions as shown below.  

![Hack Your Pipe architecture](../../rsc/hyp_architecture.png)

## Environment Preparation

Before you jump into the challenges make sure you GCP project is prepared by: 

... cloning the github repo
```
git clone https://github.com/AmritRaj23/data-journey-v2
```

... entering your GCP Project ID in `./config_env.sh` & setting all necessary environment variables.

```
source config_env.sh
```

Set the default GCP project

```
gcloud config set project $GCP_PROJECT
```

... setting your compute zone.

```
gcloud config set compute/zone $GCP_REGION

```
Enable Google Cloud APIs
```
gcloud services enable compute.googleapis.com cloudbuild.googleapis.com artifactregistry.googleapis.com dataflow.googleapis.com
```
... moving to the challenge directory
```
cd data-journey/Data-Simulator
```

... changing the project id in `./terraform.tfvars` to your own project id

... creating the PubSub Service Account. 

```
gcloud beta services identity create --project $GCP_PROJECT --service pubsub
```

... building the basic permissions & networking setup via terraform apply.

```
terraform init
```

```
terraform apply -var-file terraform.tfvars
```


<!-- ### Organizational Policies

Depending on the setup within your organization you might have to [overwrite some organizational policies](https://cloud.google.com/resource-manager/docs/organization-policy/creating-managing-policies#boolean_constraints) for the examples to run.

For example, the following policies should not be enforced. 

```
constraints/sql.restrictAuthorizedNetworks
constraints/compute.vmExternalIpAccess
constraints/compute.requireShieldedVm
constraints/storage.uniformBucketLevelAccess
constraints/iam.allowedPolicyMemberDomains
``` -->

Create bucket to store sample data source:
```
gsutil mb -l $GCP_REGION gs://$BUCKET
```

Create sample data source:
```
bq extract --destination_format NEWLINE_DELIMITED_JSON 'firebase-public-project:analytics_153293282.events_20181003' gs://$BUCKET/$FILE
```

## Building Data Simulator:

You are using Google Tag Manager for the respective ad tracking.

Your data stream is running. You need to make sure that incoming messages are ingested into the cloud reliably.

How would you ingest the data reliably based on your current knowledge? Which GCP and/or non-GCP tools would you use? 
For now focus on the ingestion part of things.
How would you collect data points and bring them into your cloud environment reliably?

No implementation needed yet. Please solely think about the architecture.

<details><summary>Hint</summary>

[Pub/Sub](https://cloud.google.com/pubsub/docs/overview) might be useful for this.

</details>


<details><summary>Suggested Solution</summary>

We will track user events on our website using [Google Tag Manager](https://developers.google.com/tag-platform/tag-manager).
To receive Google Tag manager events in our cloud environment we will use [Cloud Run](https://cloud.google.com/run/docs/overview/what-is-cloud-run) to set up a proxy service.
This proxy serves as public facing endpoint which can for example be set up as [custom tag](https://support.google.com/tagmanager/answer/6107167?hl=en) in Google Tag Manager.

To distribute the collected data points for processing you will use a [Pub/Sub](https://cloud.google.com/pubsub/docs/overview) topic.

Our starting point will look something like this:

![Hack Your Pipe architecture](../../rsc/ingestion.png)

</details>

## Step 1: Building a container
[Cloud Run](https://cloud.google.com/run/docs/overview/what-is-cloud-run) allows to set up serverless services based on a container we define.
Thus, the one of the fastest, most scalable and cost-efficient ways to build our proxy is Cloud Run.

([Click here if you need a brush-up on containers.](https://cloud.google.com/learn/what-are-containers#:~:text=Containers%20are%20packages%20of%20software,on%20a%20developer's%20personal%20laptop.))

We need to build a container with the code for our proxy server.
[Cloud Container Registry](https://cloud.google.com/artifact-registry/docs/overview) is a convenient choice for a GCP artifact repository.
But of course you could use any other container repository.

The repository `01_ingest_and_transform/11_challenge/cloud-run-pubsub-proxy` contains the complete proxy code.

Create a new container repository named `pubsub-proxy`.
Build the container described by `01_ingest_and_transform/11_challenge/cloud-run-pubsub-proxy/Dockerfile` in it.

```
gcloud builds submit $RUN_PROXY_DIR --tag gcr.io/$GCP_PROJECT/pubsub-proxy
```

Validate the successful build with:

```
gcloud container images list
```

You should see something like:
```
NAME: gcr.io/<project-id>/pubsub-proxy
Only listing images in gcr.io/<project-id>. Use --repository to list images in other repositories.
```

</details>

## Step 2:
You created a new proxy server container repo.
Next, create a new Cloud Run Service named `hyp-run-service-pubsub-proxy` based on the container you built.

Then save the endpoint URL for your service as environment variable `$ENDPOINT_URL`.


To deploy a new Cloud Run service from your container you can use:

```
gcloud run deploy hyp-run-service-pubsub-proxy --image gcr.io/$GCP_PROJECT/pubsub-proxy:latest --region=$GCP_REGION --allow-unauthenticated
```

Enter the displayed URL of your endpoint in `./config_env.sh` & reset the environment variables.

```
source config_env.sh
```

</details>


## Step 3: 
Next, a messaging queue with [Pub/Sub](https://cloud.google.com/pubsub/docs/overview) will allow us to collect all messages centrally to then distribute them for processing.

Set up a Pub/Sub topic named `dj-pubsub-topic`.


Use this command in the Cloud Shell to create the topic via command line.

```gcloud pubsub topics create dj-pubsub-topic```

OR follow [these](https://cloud.google.com/pubsub/docs/admin#pubsub_create_topic-Console) steps to create the topic via Cloud Console.

</details>

## Validate Event Ingestion

You can now stream website interaction data points through a Cloud Run Proxy Service into your Pub/Sub Topic.

The script `synth_json_stream.py` contains everything you need to simulate a stream.
Run to direct an artificial click stream at your pipeline.

```
python3 synth_json_stream.py --endpoint=$ENDPOINT_URL --bucket=$BUCKET --file=$FILE
```

After a minute or two validate that your solution is working by inspecting the [metrics](https://cloud.google.com/pubsub/docs/monitor-topic) of your Pub/Sub topic.
Of course the topic does not have any consumers yet. Thus, you should find that messages are queuing up.

By default you should see around .5 messages per second streaming into the topic.
![Pub/Sub Metrics](../../rsc/pubsub_metrics.png)

