FROM gcr.io/cloud-builders/kubectl

RUN add-apt-repository universe && \
    apt-get update -y && \
    apt-get install jq -y

COPY wrapper.bash /builder/wrapper.bash
ENTRYPOINT ["/builder/wrapper.bash"]
