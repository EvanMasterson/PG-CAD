# README
Hosted on - https://www.ncicloud.live
Custom Gem - https://rubygems.org/gems/rails-validator

* RoR versions
  ```
  rails 5.0.7.2
  
  # Gemfile
  bundle install
  ```

* Setup Configuration (AWS)
  ```
  # Install PostgreSQL and initial DB creation
  sudo yum install postgresql postgresql-server postgresql-devel postgresql-contrib postgresql-docs
  sudo service postgresql initdb
  sudo service postgresql start

  # Create user on EC2 instance for rails to connect to RDS
  sudo -u postgres createuser -s <USER>
  sudo -u postgres createdb <USER>
  sudo su postgres
  psql
  ALTER USER "<USER>" WITH SUPERUSER;
  \q
  exit
  ```

* Deployment instructions
  ```
  # Database creation/migration
  sudo service postgresql start
  rake db:create
  rake db:migrate
  
  # Deployment
  # Locally (defaults to port 3000)
  rails s
  
  # AWS (defaults to port 3000, bind to 0.0.0.0 as EC2 does not support localhost)
  rails s -e production -b 0.0.0.0 -d
  ```
