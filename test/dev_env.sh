#!/bin/bash
#
#

# runtime path is the folder one level up from the script path
SCRIPT_PATH=$(dirname "$(readlink -f "$0")")
RUNTIME_PATH=$(dirname "$SCRIPT_PATH")

# the test project is within examples/rules from the SCRIPT_PATH
TEST_PROJECT_PATH=$SCRIPT_PATH/examples/rules

cd "$TEST_PROJECT_PATH" || exit

vim --cmd "set rtp^=${RUNTIME_PATH},${SCRIPT_PATH}" . 
