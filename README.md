# Warnet Dev

These scripts are primarily for my own use, but can be adapted for 
setting up test lightning networks using [warnet](https://github.com/bitcoin-dev-project/warnet).

They set up a lightning network with the following topology, with channel
funds evenly distributed between peers:
`Alice -- Bob -- Carol -- Dave`

## Once-Off installation

- `source ./new_term.sh`
- Follow [warnet's installation instructions](https://github.com/bitcoin-dev-project/warnet/blob/main/docs/install.md#install-warnet).
  - You do not need to create a custom network with `warnet new` - those files are checked in here in `warnet`

## Regular Usage

You *must always* `source ./new_term.sh` to use the shortcuts set up in this repo!

You can do this by:
- Running `source ./new_term.sh` in every new terminal window.
- Using [warnet.yml](warnet.yml) tmuxinator template.
- Adding `source {path to new_term.sh}` to your `.bashrc` or `.zshrc`

## Shortcuts

- `start`: starts the network, opens channels, waits for gossip to sync
- `stop`: shuts down the network and cleans up all state
- `restart`: shorthand for `stop` and `start`
- `logs {node}`: gets the lightning node's logs
- `cli {node} command`: runs 
- `mine {n}`: mines n blocks (default 1)

❤️ and credit goes to @guggero who created a similar setup for internal use at LL!
This is entirely inspired by that setup, and I am so grateful for the incredible use I got out of it.
