#!/usr/bin/env bash
# File: generate_fleet_redis_bundles.sh
set -euo pipefail

BASE_DIR="test-10613"
TOTAL=70
BUNDLE_PREFIX="redis-bundle"
NS_PREFIX="redis-ns"
IMAGE="redis:7.0"

mkdir -p "$BASE_DIR"

for i in $(seq 1 "$TOTAL"); do
  NS="${NS_PREFIX}-${i}"
  BUNDLE_DIR="${BASE_DIR}/${BUNDLE_PREFIX}-${i}"
  mkdir -p "${BUNDLE_DIR}/manifests"

  # Let Helm create the namespace for this release
  cat > "${BUNDLE_DIR}/fleet.yaml" <<EOF
defaultNamespace: ${NS}
helm:
  releaseName: test-ds-${BUNDLE_PREFIX}-${i}
  install:
    createNamespace: true
EOF

  # No Namespace object here 👇
  cat > "${BUNDLE_DIR}/manifests/redis.yaml" <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis
  namespace: ${NS}
  labels:
    app: redis
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - name: redis
        image: ${IMAGE}
        ports:
        - containerPort: 6379
        resources:
          requests:
            cpu: "50m"
            memory: "64Mi"
          limits:
            cpu: "250m"
            memory: "256Mi"
---
apiVersion: v1
kind: Service
metadata:
  name: redis
  namespace: ${NS}
spec:
  type: ClusterIP
  selector:
    app: redis
  ports:
  - name: redis
    port: 6379
    targetPort: 6379
EOF

  echo "✓ Created ${BUNDLE_DIR} targeting namespace ${NS}"
done

echo "All done. Commit & push under ${BASE_DIR}/"

