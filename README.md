# Terrain

Opinionated toolkit for building CRUD APIs with Rails

* error handling
* basic CRUD
* serialization via
* authorization via [Pundit](https://github.com/elabs/pundit)

## Install

Add Terrain to your Gemfile:

```ruby
gem 'terrain'
```

## Usage

### Error handling

```ruby
class ExampleController < ApplicationController
  include Terrain::Errors
end
```

Rescues the following errors:

* `ActiveRecord::AssociationNotFoundError` (400)
* `Pundit::NotAuthorizedError` (403)
* `ActiveRecord::RecordNotFound` (404)
* `ActionController::RoutingError` (404)
* `ActiveRecord::RecordInvalid` (422)

JSON responses are of the form:

```json
{
  "error": {
    "key": "type_of_error",
    "message": "Localized error message"
  }
}
```

To rescue a custom error with a similar response:

```ruby
class ExampleController < ApplicationController
  include Terrain::Errors

  rescue_from MyError, with: :my_error

  private

  def my_error
    error_response(:type_of_error, 500)
  end
end
```

### Resources

Suppose you have an `Example` model with `foo`, `bar`, and `baz` columns.

```ruby
class ExampleController < ApplicationController
  include Terrain::Resource

  resource Example, permit: [:foo, :bar, :baz]
end
```

This sets up the typical resourceful Rails controller actions.  Note that **you'll still need to setup corresponding routes**.

#### Authorization

Authorization is handled by [Pundit](https://github.com/elabs/pundit).  If the policy class for a given resource exists, each controller action calls the policy before proceeding with the operation.  Authorization expects a `current_user` controller method to exist (otherwise `nil` is used as the `pundit_user`).

#### Serialization

via [ActiveModelSerializers](https://github.com/rails-api/active_model_serializers)

#### Querying

* `include` - This corresponds to the `ActiveModelSerializers` include option and embeds the given relationships in the response.  Relationships are also preloaded according to the given string.  If omitted then no relationships will be included or embedded in the response.

#### CRUD operations

You may need an action to perform additional steps beyond simple persistence.  There are hooks for each CRUD operation (shown below with their default implementation):

```ruby
class ExampleController < ApplicationController
  include Terrain::Resource

  resource Example, permit: [:foo, :bar, :baz]

  private

  def create_record
    resource.create!(permitted_params)
  end

  def update_record(record)
    record.update_attributes!(permitted_params)
    record
  end

  def destroy_record(record)
    record.delete
  end
end
```
