#!/bin/bash

packer build -var "aws_access_key=$AWS_ACCESS_KEY" -var "aws_secret_key=$AWS_SECRET_KEY" -on-error=ask $1 cod4mw_server.json $2
