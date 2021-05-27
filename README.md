# Wrap
[![Build Status](https://github.com/fremantle-industries/wrap/workflows/test/badge.svg?branch=main)](https://github.com/fremantle-industries/wrap/actions?query=workflow%3Atest)
[![Coverage Status](https://coveralls.io/repos/github/fremantle-industries/wrap/badge.svg?branch=main)](https://coveralls.io/github/fremantle-industries/wrap?branch=main)
[![hex.pm version](https://img.shields.io/hexpm/v/wrap.svg?style=flat)](https://hex.pm/packages/wrap)

Build, Publish & Deploy Elixir Infrastructure to the Cloud.

`wrap` is an opinionated set of `mix` tasks that:

- Builds an OTP release within [Docker](https://www.docker.com/)
- Publishes the container to a registry
- Deploys cloud infrastructure via [Terraform](https://www.terraform.io/)

## Installation

Add `wrap` to your list of dependencies in `mix.exs`

```elixir
def deps do
  [
    {:wrap, "~> 0.0.8"}
  ]
end
```

## Setup

Before using `wrap` run the setup task to create the required directory structure.

```
mix wrap.setup
```

## Usage

TODO...

```bash
```

## Tasks

```bash
$ mix wrap.gen.wrapper    # Scaffold a wrapper module
```

```bash
$ mix wrap.gen.present    # Scaffold a release present
```

```bash
$ ix wrap.list           # List presents
```

```bash
$ mix wrap.build          # Build docker images for elixir releases
```

```bash
$ mix wrap.publish        # Publish latest docker images
```

```bash
$ mix wrap.init           # Init the release present for terraform
```

```bash
$ mix wrap.plan           # Plan terraform definition
```

```bash
$ mix wrap.apply          # Apply terraform definition
```

```bash
$ mix wrap.destroy        # Destroy terraform resources
```
