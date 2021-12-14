ARG MARKETPLACE_TOOLS_TAG
FROM gcr.io/cloud-marketplace-tools/k8s/deployer_envsubst:$MARKETPLACE_TOOLS_TAG

RUN mkdir -p /data/artifacts

COPY manifest /data/manifest
COPY artifacts /data/artifacts
COPY schema.yaml /data/
COPY apptest/deployer /data-test/

RUN curl -Lo /usr/local/bin/tctl https://binaries.dl.tetrate.io/public/raw/versions/linux-amd64-1.3.0/tctl && chmod +x /usr/local/bin/tctl
RUN rm -rf /bin/kubectl && curl -Lo /bin/kubectl  https://dl.k8s.io/release/v1.23.0/bin/linux/amd64/kubectl && chmod +x /bin/kubectl

# Provide registry prefix and tag for default values for images.
ARG REGISTRY
ARG TAG
RUN cat /data/schema.yaml \
    | env -i "REGISTRY=$REGISTRY" "TAG=$TAG" envsubst \
    > /data/schema.yaml.new \
    && mv /data/schema.yaml.new /data/schema.yaml

RUN cat /data-test/schema.yaml \
    | env -i "REGISTRY=$REGISTRY" "TAG=$TAG" envsubst \
    > /data-test/schema.yaml.new \
    && mv /data-test/schema.yaml.new /data-test/schema.yaml

ENV WAIT_FOR_READY_TIMEOUT 3600
ENV TESTER_TIMEOUT 3600
