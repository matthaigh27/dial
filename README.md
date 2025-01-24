# Dial

![Version](https://img.shields.io/gem/v/dial)
![Build](https://img.shields.io/github/actions/workflow/status/joshuay03/dial/.github/workflows/main.yml?branch=main)

WIP

A modern profiler for Rails applications.

Check out the demo:
[![Demo](https://img.youtube.com/vi/LPXtfJ0c284/maxresdefault.jpg)](https://youtu.be/LPXtfJ0c284)

## Installation

1. Add the gem to your Rails application's Gemfile (adjust the `require` option to match your server of choice):

```ruby
# require in just the server process
gem "dial", require: !!($PROGRAM_NAME =~ /puma/)
```

2. Install the gem:

```bash
bundle install
```

3. Mount the engine in your `config/routes.rb` file:

```ruby
# this will mount the engine at /dial
mount Dial::Engine, at: "/" if Object.const_defined?("Dial::Engine")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake test` to run the
tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joshuay03/dial.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dial project's codebases, issue trackers, chat rooms and mailing lists is expected to follow
the [code of conduct](https://github.com/joshuay03/dial/blob/main/CODE_OF_CONDUCT.md).
