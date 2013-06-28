#!/bin/bash

exec /bin/su - ubuntu -c "$(dirname $0)/input.py"

