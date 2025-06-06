#/bin/bash
# This assumes it runs on a manager node
# Load environment variables
export $(grep -v '^#' .env | xargs)

STACK_NAME="pleroma" # stack name
DB_NODE_NAME="worker-1" # hostname of node where the DB will run on

docker config rm init_script
docker config create init_script ./init-pleroma.sh
docker config rm pleroma_config
docker config create pleroma_config ./prod.secret.exs

for node in $(docker node ls --filter role=worker --format '{{.ID}}'); do
    docker node update --label-rm pleroma_nd "$node"
done
docker node update --label-add pleroma_nd=true $DB_NODE_NAME

docker stack deploy -c docker-stack.yml $STACK_NAME