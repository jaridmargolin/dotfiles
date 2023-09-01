#!/bin/bash

# ##############################################################################
#
# docker.sh
#
# Common helpers/aliases for working with docker.
#
# ##############################################################################


dock() { eval $(docker-machine env $1) }
undock() { eval $(docker-machine env -u) }

# prune docker images
dprune() {
    prune_images=$(docker images --filter "dangling=true" -q --no-trunc)
    if [ -n "$prune_images" ]; then
        echo "Pruning images"
        docker rmi $prune_images
    else
        echo "No images to prune"
    fi
}
