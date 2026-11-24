#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

IMAGE="duoc/jv0101-caso02-postulaciones:1.0.0"

START=$(date +%s)

echo "=== CONSTRUYENDO IMAGEN ==="
docker build -t "$IMAGE" .

echo "=== CARGANDO IMAGEN EN KUBERNETES ==="
minikube image load "$IMAGE" --overwrite=true

echo "=== DESPLEGANDO RECURSOS ==="
kubectl apply -f k8s/namespace.yml
kubectl apply -f k8s/deployment.yml
kubectl apply -f k8s/service.yml

kubectl rollout restart deployment/postulaciones-svc \
  -n postulaciones

echo "=== VERIFICANDO DISPONIBILIDAD ==="
kubectl rollout status deployment/postulaciones-svc \
  -n postulaciones --timeout=180s

kubectl get pods -n postulaciones
kubectl get services -n postulaciones

END=$(date +%s)

echo "=== DESPLIEGUE EXITOSO ==="
echo "Duracion: $((END - START)) segundos"
