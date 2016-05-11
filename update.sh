#!/usr/bin/env bash
docker build -t builder -f Dockerfile_update .
docker run --rm builder > requirements.txt

