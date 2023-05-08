FROM python:3.8-slim

ENV PROJECT_ID=streaming-data-journey
ENV BUCKET_NAME=dataflow-bucket-dj
ENV REGION=us-central1

# Install SDK.
RUN pip install --no-cache-dir apache-beam[gcp]==2.46.0

# Verify that the image does not have conflicting dependencies.
RUN pip check

# Copy files from official SDK image, including script/dependencies.
COPY --from=apache/beam_python3.8_sdk:2.46.0 /opt/apache/beam /opt/apache/beam

# Set the entrypoint to Apache Beam SDK launcher.
ENTRYPOINT ["/opt/apache/beam/boot"]
