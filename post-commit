#!/bin/sh
if [ `git rev-parse --abbrev-ref HEAD` == "deploy" ]; then
curl http://jenkins:8080/job/magic/build
fi
