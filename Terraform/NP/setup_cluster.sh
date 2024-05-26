#!/bin/bash

# Function to handle failure based on specific error message
handle_installation_error() {
    release_name=$1
    if [[ $? -ne 0 ]]; then
        # Capture the error message
        error_message=$(helm install $release_name 2>&1)

        # Check if the error message is about re-using a name
        if echo $error_message | grep -q "cannot re-use a name that is still in use"; then
            echo "Warning: $release_name is already installed or in use. Continuing..."
        else
            echo "Error: Installation of $release_name failed. Exiting script."
            exit 1
        fi
    fi
}

# Apply sock-shop
kubectl apply sock-shop.yaml

# Create namespaces
kubectl create namespace loki
kubectl create namespace tempo
kubectl create namespace prometheus
kubectl create namespace otel

# Add Helm repositories and update
echo "Adding Helm repositories..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Install prometheus
echo "Installing prometheus..."
helm install prometheus prometheus-community/prometheus --namespace prometheus
handle_installation_error "prometheus"

# Install tempo
echo "Installing tempo..."
helm -n tempo install tempo grafana/tempo-distributed -f tempo_values.yaml
handle_installation_error "tempo"

# Install loki
echo "Installing loki..."
helm upgrade --install --namespace loki logging grafana/loki -f loki_values.yaml --set loki.auth_enabled=false
handle_installation_error "loki"

# Install Grafana
echo "Installing Grafana..."
helm upgrade --install --namespace=loki loki-grafana grafana/grafana
handle_installation_error "grafana"

# Install otel
echo "Installing otel..."
helm install otel-collector open-telemetry/opentelemetry-collector \
--namespace otel \
-f otel_values.yaml
handle_installation_error "otel"

# Port-forward Grafana service
echo "Setting up port-forwarding for Grafana..."
sudo kubectl port-forward --namespace loki service/loki-grafana 3000:80 &
sudo kubectl port-forward service/prometheus-server 80 -n prometheus &

echo "All installations and port-forwarding completed successfully."

