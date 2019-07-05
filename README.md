# TAP Ruby Test

## Task

Create Rails application for inviting new users with Devise and DeviseInvitable. Main feature of
the application is the ability to send invitations for new Users to be able to register and access
Project. Each User is invited by email, name, Role, Location and Project. Each User belongs to
Project with specific Role. User can belong to multiple Projects with different or same Roles.
Project can have multiple Locations and User can belong to multiple Locations.

Second main feature is the ability to remove User from the Project. With this all Location
associations and everything else should be deleted.

## System dependencies

* Ruby version >= 2.6
* Rails version >= 5.2
* PostgreSQL server version >= 10
* GraphQL client, for example Altair

## Configuration

```
cp .env.sample .env
bundle exec rake secret # and update this newly generated secret in .env
bundle install
rake db:create db:migrate
rails db:seed
```

## Run instructions

```
rails s
```

Get user's JSON Web Token from query or by running in rails console: ```User.first.token```.

Then set "Authorization" header to this value in GraphQL client.

## GraphQL queries' examples

* Get the specified user (applies for current user or Admin only):
```
query user {
  user(id: 1) {
    id
    name
    email
    token
    projects {
      id
      name
    }
    roles {
      name
    }
    locations {
      name
    }
  }
}
```

* Get all users with assigned projects, roles and locations (applies for Admin only):
```
query users {
  users {
    id
    name
    projects {
      id
      name
    }
    roles {
      name
    }
    locations {
      name
    }
  }
}
```

* Get the specified project:
```
query project {
  project(id: 2) {
    id
    name
  }
}
```

* Get all projects for current user:
```
query projects {
  projects {
    id
    name
  }
}
```

* Get all roles for current user:
```
query roles {
  roles {
    id
    name
  }
}
```

* Get all locations for current user:
```
query locations {
  locations {
    id
    name
  }
}
```

## GraphQL mutations' examples

* Delete the specified user and destroy all belonging resources (applies for current user or Admin only):
```
mutation deleteUser {
  deleteUser(input: {id: 3}) {
    success
  }
}
```

## License

Please refer to [LICENSE](LICENSE).
