#!/usr/bin/env BASH

awk '{print $1, $11}' <(ps aux)
