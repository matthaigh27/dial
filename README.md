# Dial

![Version](https://img.shields.io/gem/v/dial)
![Build](https://img.shields.io/github/actions/workflow/status/joshuay03/dial/.github/workflows/main.yml?branch=main)

WIP

A modern profiler for Rails applications.

Check out the demo:
[![Demo](https://img.youtube.com/vi/LPXtfJ0c284/maxresdefault.jpg)](https://youtu.be/LPXtfJ0c284)

## Installation

1. Install the gem and add it to your Rails application's Gemfile by executing:

```bash
bundle add dial
```

2. Mount the engine in your `config/routes.rb` file:


```ruby
# this will mount the engine at /dial
mount Dial::Engine, at: "/"
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
