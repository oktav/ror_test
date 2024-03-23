# README

Create postgres db with docker
$ docker run --name postgres_16 --net=host -e POSTGRES_PASSWORD=secret -d postgres:16

Add user to db
$ docker exec -it --user postgres postgres_16 psql
create role ror_test with createdb login password 'secret';

Create redis container
docker run --name redis-server -d --net=host redis redis-server --save 60 1 --loglevel warning

Build main app
docker build -t ror_test .

Main app

Make sure .env file exists in rails root dir with at least the following lines:
RAILS_ENV=development
DATABASE_URL=postgres://ror_test:secret@localhost/ror_test_development
VPN_API_KEY=<your VPNAPI key here>

Can run in production but needs database setup first and change the RAILS_ENV in the .env file

Run main container
docker run -d --env-file .env \
           -v $(pwd):/rails \
           --net=host \
           --name ror_test \
           ror_test \
           bundle exec rails s

PGadmin if we don't like CLI
docker run -d -e PGADMIN_DEFAULT_PASSWORD=secret -e PGADMIN_DEFAULT_EMAIL=oktav2k3@gmail.com --net=host --name=pgadmin dpage/pgadmin4