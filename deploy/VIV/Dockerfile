# Use a base image with the necessary tools
FROM alpine:latest

  # Install bash, curl, and other necessary tools
RUN apk add --no-cache bash curl

# Install kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/

# Install Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

  # Add your script to the container
COPY ../../Terraform/NP/setup_cluster.sh /usr/local/bin/setup_cluster.sh
RUN chmod +x /usr/local/bin/setup_cluster.sh

  # Set the entry point to your script
ENTRYPOINT ["/usr/local/bin/setup_cluster.sh"]