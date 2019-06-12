[![Gem Version](https://badge.fury.io/rb/pickel.svg)](https://badge.fury.io/rb/pickel)
[![Build Status](https://travis-ci.org/sinsoku/pickel.svg?branch=master)](https://travis-ci.org/sinsoku/pickel)

# Pickel

Pickel provides methods that make it easy to build a search form for your Rails app.

## Installation

Add this line to your Rails application's Gemfile:

```ruby
gem 'pickel'
```

## Usage

1. Allow parameters available for search.
2. Create an object with the `Pickel.search` method.
3. Create a search form with the `form_for` method.

### In controller

```ruby
def index
  search_params = Pickel.permit(params, :name, :age_gt, :posts_title_start)
  @search = Pickel.search(User, search_params)
  @users = @search.result
end
```

### In view

```erb
<%= form_for @search do |f| %>
  <%# Search records contains the value %>
  <%= f.label :name_cont %>
  <%= f.search_field :name_cont %>

  <%# Search records grater than the value %>
  <%= f.label :age_gt %>
  <%= f.number_field :age_gt %>

  <%# Search records an associated posts.title starts with the value %>
  <%= f.label :posts_title_start %>
  <%= f.search_field :posts_title_start %>

  <%= f.submit %>
<% end %>
```

## Support predicates

| Predicate     | Description                        |
|---------------|------------------------------------|
| `*_eq`        | equals                             |
| `*_not_eq`    | not equal                          |
| `*_in`        | in                                 |
| `*_not_in`    | not in                             |
| `*_lt`        | less than                          |
| `*_lteq`      | less than or equal                 |
| `*_gt`        | greater than                       |
| `*_gteq`      | greater than or equal              |
| `*_matches`   | matches with `LIKE`                |
| `*_cont`      | contains                           |
| `*_not_cont`  | not contain                        |
| `*_start`     | starts                             |
| `*_not_start` | not start                          |
| `*_end`       | ends                               |
| `*_not_end`   | not end                            |
| `*_true`      | is `true`                          |
| `*_false`     | is `false`                         |
| `*_null`      | is `NULL`                          |
| `*_not_null`  | is not `NULL`                      |
| `*_blank`     | is `NULL` or empty string          |
| `*_present`   | is not `NULL` and not empty string |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sinsoku/pickel. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Pickel project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sinsoku/pickel/blob/master/CODE_OF_CONDUCT.md).
