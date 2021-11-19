[![CircleCI](https://circleci.com/gh/unchartedelixir/demo/tree/master.svg?style=svg)](https://circleci.com/gh/unchartedelixir/demo/tree/master)
# Uncharted Examples
Uncharted is a simple ***Elixir*** charting library that generates easy to customize charts.

View the Uncharted Demo [here](https://unchartedelixir.herokuapp.com/)

This demo is a working example of each of the [Uncharted Phoenix](https://github.com/unchartedelixir/uncharted/tree/master/uncharted_phoenix) chart types. Uncharted Phoenix is a LiveView adaptation of the core [Uncharted](https://github.com/unchartedelixir/uncharted/tree/master/uncharted) package.

For more information about the core library, please visit the [Uncharted HexDocs](https://hexdocs.pm/uncharted/readme.html).
For more information about the LiveView adaptation seen in this demo, please visit the [Uncharted Phoenix HexDocs](https://hexdocs.pm/uncharted_phoenix/readme.html).

***Charts Included***:
- The Pie Chart
- The Column Chart
- The Progress Chart
- The Line Chart
- The Bar Chart

To start the demo Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser to see the charts.

## Contributing

We appreciate any contribution to Uncharted!

To contribute feedback, please open a GitHub issue.

To contribute a specific feature or bugfix, please open a PR. Before submitting your PR, we ask you to run the Elixir
tests, lint, and formatting tools we use on the project. If you have a contribution to make but don't know how to run
the tools below, go ahead and open it and we will help you. For larger changes, open an issue first so that we can have
a discussion before you put a lot of work into a PR.

To run the tests and formatting tools:

```
$ mix deps.get
$ mix test
$ mix format
$ mix credo--strict
 ```

Our current `mix.exs` setup in this demo assumes that you will have Uncharted cloned into the same directory where you have this demo cloned. If necessary, you can change the paths to your local versions of Uncharted and Uncharted Phoenix by updating the `@uncharted_path` instance variable. Just be sure not to commit this change.
