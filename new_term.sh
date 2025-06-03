#!/bin/bash

python3 -m venv .venv
source .venv/bin/activate

fn start() {
  echo "Deploying network"
  warnet deploy warnet/networks/lightning
  echo "Opening Channels"
  warnet run warnet/scenarios/ln_init.py
  echo "Waiting for gossip to sync"
  wait_for_scenario "gossip sync"
}

fn stop() {
  warnet down
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

# Waits for warnet to have no actively running scenarios.
fn wait_for_scenario() {
  scenario_name="$1"

  if [ -z "$scenario_name" ]; then
    echo "Usage: wait_for_scenario <scenario_name>"
    return 1
  fi

  echo "Waiting for scenario '$scenario_name' to finish..."

  while true; do
    output=$(warnet status)

    # Get active scenario count
    active_scenarios=$(echo "$output" | grep "Active Scenarios" | awk -F': ' '{print $2}')

    if [[ "$active_scenarios" == "0" ]]; then
      echo "Scenario '$scenario_name' has finished."
      break
    else
      echo "Scenario '$scenario_name' still running"
      sleep 5
    fi
  done
}
