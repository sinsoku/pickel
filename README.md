# Searching

Searching provides methods that make it easy to create search forms for your Rails app.

## Installation

Add this line to your Rails application's Gemfile:

```ruby
gem 'searching'
```

## Usage

1. Allow parameters available for search.
2. Create an object with the `searching` method.
3. Create a search form with the `search_form_for` method.

## in controller

```ruby
def index
  @search = User.searching(search_params)
  @users = @search.result
end

private

def search_params
  params.permit(:name_cont, :age_gt, :posts_title_start)
end
```

## in view

```erb
<%= search_form_for @search do |f| %>
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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sinsoku/searching. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Searching project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/searching/blob/master/CODE_OF_CONDUCT.md).
