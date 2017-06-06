#!/usr/bin/env bash
autossh -M 0 -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" \
           -L 9999:localhost:8888 -N jhhuh@nixos
