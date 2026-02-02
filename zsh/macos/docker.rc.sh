#!/bin/zsh

# ##############################################################################
#
# docker.rc.sh
# Common helpers/aliases for working with docker.
#
# ##############################################################################

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
