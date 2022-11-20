# RSS Feed

This is a simple utility to manage RSS feeds for your reading pleasure.

## Installation

This project manages its underlying development system dependencies with [asdf](https://asdf-vm.com/guide/getting-started.html#_2-download-asdf).

In addition to `asdf`, you must install some Erlang [prerequesites](https://github.com/asdf-vm/asdf-erlang#before-asdf-install).

On Ubuntu and Debian it's the following:
```sh
apt-get update
apt-get -y install libncurses5-dev \
                   build-essential \
                   autoconf \
                   xsltproc \
                   fop \
                   libxml2-utils
```

Once `asdf` and its necessary dependencies are installed, you can simply run
```sh
asdf install
```

This will leverage the `.tool-versions` file to install the currently required versions of Elixir and Erlang.