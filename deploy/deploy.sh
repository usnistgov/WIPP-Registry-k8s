#!/usr/bin/env bash

export $(egrep -v '^#' .env)

# Backup file extension required to support Mac versions of sed
sed -i.bak \
    -e "s|ALLOWED-HOSTS|${ALLOWED_HOSTS}|g" \
    -e "s|DJANGO-SECRET-KEY|${DJANGO_SECRET_KEY}|g" \
    -e "s|DJANGO-SETTINGS-MODULE|${DJANGO_SETTINGS_MODULE}|g" \
    -e "s|MONGO-DB|${MONGO_DB}|g" \
    -e "s|MONGO-HOST|${MONGO_HOST}|g" \
    -e "s|MONGO-PASS|${MONGO_PASS}|g" \
    -e "s|MONGO-USER|${MONGO_USER}|g" \
    -e "s|POSTGRES-DB|${POSTGRES_DB}|g" \
    -e "s|POSTGRES-HOST|${POSTGRES_HOST}|g" \
    -e "s|POSTGRES-PASS|${POSTGRES_PASS}|g" \
    -e "s|POSTGRES-PORT|${POSTGRES_PORT}|g" \
    -e "s|POSTGRES-USER|${POSTGRES_USER}|g" \
    -e "s|REDIS-HOST|${REDIS_HOST}|g" \
    -e "s|REDIS-PASS|${REDIS_PASS}|g" \
    -e "s|SERVER-NAME|${SERVER_NAME}|g" \
    -e "s|SERVER-URI|${SERVER_URI}|g" \
    -e "s|DJANGO-SETTINGS|${DJANGO_SETTINGS}|g" \
    deploy/secrets/wipp-registry-cdcs.yaml
rm deploy/secrets/wipp-registry-cdcs.yaml.bak

sed -i.bak \
    -e "s|MONGO-INITDB-DATABASE|${MONGO_INITDB_DATABASE}|g" \
    -e "s|MONGO-INITDB-ROOT-PASSWORD|${MONGO_INITDB_ROOT_PASSWORD}|g" \
    -e "s|MONGO-INITDB-ROOT-USERNAME|${MONGO_INITDB_ROOT_USERNAME}|g" \
    -e "s|MONGO-PASS|${MONGO_PASS}|g" \
    -e "s|MONGO-USER|${MONGO_USER}|g" \
    deploy/secrets/wipp-registry-mongodb.yaml
rm deploy/secrets/wipp-registry-mongodb.yaml.bak

sed -i.bak \
    -e "s|POSTGRES-DB|${POSTGRES_DB}|g" \
    -e "s|POSTGRES-PASSWORD|${POSTGRES_PASS}|g" \
    -e "s|POSTGRES-USER|${POSTGRES_USER}|g" \
    deploy/secrets/wipp-registry-postgres.yaml
rm deploy/secrets/wipp-registry-postgres.yaml.bak

sed -i.bak \
    -e "s|REDIS-PASS|${REDIS_PASS}|g" \
    deploy/secrets/wipp-registry-redis.yaml
rm deploy/secrets/wipp-registry-redis.yaml.bak

rm k8s/django-ingress.yaml

kubectl apply --kubeconfig=${KUBECONFIG} -f deploy/secrets/

kubectl apply --kubeconfig=${KUBECONFIG} -f k8s/postgres-database-persistent-volume-claim.yaml
kubectl apply --kubeconfig=${KUBECONFIG} -f k8s/mongo-database-persistent-volume-claim.yaml

kubectl apply --kubeconfig=${KUBECONFIG} -f k8s/mongo-init-config-map.yaml
kubectl apply --kubeconfig=${KUBECONFIG} -f k8s/mongo-deployment.yaml
kubectl apply --kubeconfig=${KUBECONFIG} -f k8s/mongo-cluster-ip-service.yaml

kubectl apply --kubeconfig=${KUBECONFIG} -f k8s/postgres-deployment.yaml
kubectl apply --kubeconfig=${KUBECONFIG} -f k8s/postgres-cluster-ip-service.yaml

kubectl apply --kubeconfig=${KUBECONFIG} -f k8s/redis-deployment.yaml
kubectl apply --kubeconfig=${KUBECONFIG} -f k8s/redis-cluster-ip-service.yaml

kubectl apply --kubeconfig=${KUBECONFIG} -f k8s/django-deployment.yaml
