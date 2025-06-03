#!/bin/bash

python3 -m venv .venv
source .venv/bin/activate

fn start() {
  echo "Deploying network"
  warnet deploy warnet/networks/lightning
}

fn stop() {
  warnet down --force
}

fn restart() {
  stop
  start
}

fn logs() {
  tank_name=$(alias_to_tank "$1") || return 1
  kubectl logs "$tank_name"
}

fn cli() {
  if [ "$#" -ne 2 ]; then
    echo "Provide node and command: <alice|bob|carol|dave|a|b|c|d> <cli command>" >&2
    return 1
  fi

  tank_name=$(alias_to_tank "$1") || return 1
  warnet ln rpc "$tank_name" "$2"
}

fn mine() {
  blocks=${1:-1}
  warnet bitcoin rpc tank-0000 -generate "$blocks"
}

# Maps user friendly name to tank value.
fn alias_to_tank() {
  if [ "$#" -ne 1 ]; then
    echo "Provide node name: <alice|bob|carol|dave|a|b|c|d>" >&2
    return 1
  fi

  name="$1"

  case "$name" in
    alice|a)  echo "tank-0000-ln" ;;
    bob|b)    echo "tank-0001-ln" ;;
    carol|c)  echo "tank-0002-ln" ;;
    dave|d)   echo "tank-0003-ln" ;;
    *)
      echo "Unknown node specify one of: <alice|bob|carol|dave|a|b|c|d>: $name" >&2
      return 1
      ;;
  esac
}
