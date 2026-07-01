#!/usr/bin/env bash

# This script demonstrates process substitution.
# It uses process substitution to send the output of `ps aux` to `awk`.
# This is more efficient than using a traditional pipe (`|`) because it avoids
# creating a subshell.

awk '{print $1, $11}' <(ps aux)
