# Dial

![Version](https://img.shields.io/gem/v/dial)
![Build](https://img.shields.io/github/actions/workflow/status/joshuay03/dial/.github/workflows/main.yml?branch=main)

WIP

A modern profiler for Rails applications.

Check out the demo:
[![Demo](https://img.youtube.com/vi/LPXtfJ0c284/maxresdefault.jpg)](https://youtu.be/LPXtfJ0c284)

## Installation

1. Add the gem to your Rails application's Gemfile:

```ruby
group :development do
  gem "dial"
end
```

2. Install the gem:

```bash
bundle install
```

3. Mount the engine in your `config/routes.rb` file:

```ruby
# this will mount the engine at /dial
mount Dial::Engine, at: "/" if Rails.env.development?
```

4. (Optional) Configure the gem in an initializer:

```ruby
# config/initializers/dial.rb

Dial.configure do |config|
  config.vernier_interval = 100 # default: 200
  config.vernier_allocation_interval = 10_000 # default: 20_000
  config.prosopite_ignore_queries += [/pg_sleep/i] # default: [/schema_migrations/i]
end
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
