# README

* RoR versions
  ```
  ruby 2.6.3
  rails 5.0.7.2
  
  # Gemfile
  bundle install
  ```

* Setup Configuration (Linux/AWS)
  ```
  # Install PostgreSQL and initial DB creation
  sudo yum install postgresql postgresql-server postgresql-devel postgresql-contrib postgresql-docs
  sudo service postgresql initdb
  sudo service postgresql start

  # Create user for rails to connect to DB
  sudo -u postgres createuser -s ec2-user
  sudo -u postgres createdb ec2-user
  sudo su postgres
  psql
  ALTER USER "ec2-user" WITH SUPERUSER;
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
  
  # AWS (defaults to port 8080, change IP to EC2 Private IP)
  rails s -b $IP
  ```
