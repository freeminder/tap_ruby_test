# TAP Ruby Test

[![Ruby Style Guide](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/testdouble/standard)

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

## GraphQL request examples

* Invite user by email, name, project, role and location (only Admin can invite new users):
```
mutation inviteUser {
  inviteUser(input: {
    email: "user4@example.com",
    name: "Jet Lee",
    projectId: 3,
    roleId: 1,
    locationId: 10
  }) {
    success
    errors {
      message
    }
  }
}
```

* Sign in:
```
mutation login {
  login(email: "user1@example.com", password: "qwertyIsB@dP@$$w0rd!") {
      id
      name
      email
      token
  }
}
```

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

* Get all users with assigned projects, roles and locations (Admin only):
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

* Create a project (Admin only):
```
mutation createProject {
  createProject(input: {
    name: "ProjectA2"
  }) {
    success
    errors {
      message
    }
  }
}
```

* Add a user with specified role and location to the project (Admin only):
```
mutation addUserToProject {
  addUserToProject(input: {
    userId: 3
    projectId: 2,
    roleId: 1,
    locationId: 10
  }) {
    success
    errors {
      message
    }
  }
}
```

* Get the specified project (will return resource object only if user is Admin or assigned to this project):
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

* Remove the specified user from project with this all location associations and everything else (Admin only):
```
mutation removeUserFromProject {
  removeUserFromProject(input: {
    userId: 3,
    projectId: 3
  }) {
    success
  }
}
```

* Delete the specified user and destroy all belonging resources (current user or Admin only):
```
mutation deleteUser {
  deleteUser(input: {id: 3}) {
    success
  }
}
```

## Tests

* Syntax/Lint:
```
rake standard
```

* Tests:
```
rspec -fd
```

## License

Please refer to [LICENSE](LICENSE).
