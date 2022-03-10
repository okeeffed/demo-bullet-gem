# README

The following are the steps taken for this project.

## Getting started

```s
# Create new rails projects
$ rails new demo-bullet-n-plus-1
$ cd demo-bullet-n-plus-1

# Add gem
$ bundler add bullet --group="development"
# Set up bullet
$ bin/rails g bullet:install
```

## Setting up the dev environment

In `config/environments/development.rb`:

```rb
# @see https://github.com/flyerhzm/bullet
config.after_initialize do
  Bullet.enable = true
  Bullet.console = true
end
```

Bullet can catch more than just **N+1** queries, but we will focus on that first.

## Creating our demo models

```s
# Create our controller to test against
$ bin/rails g controller home index

# Add some models to map a relationship to
$ bin/rails g model User name:string
$ bin/rails g model Document body:string
$ bin/rails g migration add_user_to_document user:references
```

Update `app/models/user.rb`:

```rb
class User < ApplicationRecord
  has_many :documents
end
```

Update `app/models/document.rb`:

```rb
class Document < ApplicationRecord
  belongs_to :user
end
```

## Seeds

In `db/seeds.rb`:

```rb
users = User.create([
                      { name: 'Bob' },
                      { name: 'Sally' },
                      { name: 'Joe' }
                    ])

users.each do |user|
  user.documents.create([
                          { user_id: user.id, body: "This is a document for #{user.name}" },
                          { user_id: user.id, body: "This is another document for #{user.name}" },
                          { user_id: user.id, body: "This is a third document for #{user.name}" },
                          { user_id: user.id, body: "This is a fourth document for #{user.name}" }
                        ])
end
```

## Create, migrate and seed database

```s
# Run all database actions
$ bin/rails db:create db:migrate db:seed
```

## Routes

```rb
Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :home, only: [:index]
end
```

## HomeController to demonstrate Bullet eager loading

```rb
class HomeController < ApplicationController
  def index
    users = User.includes(:documents).all

    render json: users
  end
end
```

We will get a warning in our Rails console:

```s
GET /home
AVOID eager loading detected
  User => [:documents]
  Remove from your query: .includes([:documents])
```

Remove that and the error will be gone.

Next, we can demo the need for eager loading:

```rb
class HomeController < ApplicationController
  def index
    users = User.all
    document_contents = []
    users.each do |user|
      document_contents << user.documents.map(&:body)
    end

    render json: { users: users, document_contents: document_contents }
  end
end
```

Again, run a GET request to `/home` and you'll get the following:

```s
GET /home
USE eager loading detected
  User => [:documents]
  Add to your query: .includes([:documents])
```

Finally, to get an N+1 query, let's got back to a basic home controller:

```rb
class HomeController < ApplicationController
  def index
    @users = User.all
  end
end
```

Update `app/views/home/index.html.erb`:

```html
<h1>Home#index</h1>
<p>Find me in app/views/home/index.html.erb</p>
<table>
  <thead>
    <tr>
      <th>User ID</th>
      <th>Body</th>
    </tr>
  </thead>
  <tbody>
    <% users.each do |user| %>
    <tr>
      <td><%= user.id %></td>
      <td><%= user.document.map(&:body) %></td>
    </tr>
    <% end %>
  </tbody>
</table>
```
