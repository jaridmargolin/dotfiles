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
