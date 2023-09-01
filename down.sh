#!/bin/bash

thisDir=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")

docker compose -f "$thisDir"/docker-compose.yml down
