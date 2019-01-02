#/bin/bash
set -exaf
docker build . --tag=test --build-arg LIBNFC_REPOSITORY="https://github.com/MaitreDede/libnfc.git" --build-arg LIBNFC_BRANCH="feat/ledbuzz"
docker run --rm -it test