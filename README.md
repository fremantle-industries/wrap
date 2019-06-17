# Wrap

Build, Publish & Deploy Infrastructure to the Cloud

## Installation

Add `wrap` to your list of dependencies in `mix.exs`

```elixir
def deps do
  [
    {:wrap, "~> 0.0.2"}
  ]
end
```

## Usage

```
mix wrap.list          # List packages
mix wrap.build         # Build docker images from distillery releases
mix wrap.publish       # Publish latest docker images
mix wrap.plan          # Plan terraform definition
mix wrap.apply         # Apply terraform definition
mix wrap.destroy       # Destroy packages
```
