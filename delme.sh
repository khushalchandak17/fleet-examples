#!/bin/bash
# File: generate_redis_deployments.sh
# Usage: ./generate_redis_deployments.sh

BASE_DIR="test-10613"
TOTAL=70

mkdir -p "$BASE_DIR"

for i in $(seq 1 $TOTAL); do
  NS="redis-ns-$i"
  DEPLOY_NAME="redis-deploy-$i"
  DIR="$BASE_DIR/$NS"

  mkdir -p "$DIR"

  cat > "$DIR/deployment.yaml" <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NS
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $DEPLOY_NAME
  namespace: $NS
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
        image: redis:7.0
        ports:
        - containerPort: 6379
EOF

done

echo "✅ Generated $TOTAL Redis deployments under $BASE_DIR/"

