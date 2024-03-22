# README

DB running in docker

docker run --name postgres_16 --net=host -e POSTGRES_PASSWORD=secret -d postgres:16
docker exec -it --user postgres postgres_16 psql
create role ror_test with createdb login password 'secret';

Build ror_test

docker build -t ror_test .

Start rails container with
docker run -d --env-file .env \
           -v $(pwd):/rails \
           --net=host \
           --name ror_test \
           ror_test \
           bundle exec rails s


PGadmin
docker run -d -e PGADMIN_DEFAULT_PASSWORD=secret -e PGADMIN_DEFAULT_EMAIL=oktav2k3@gmail.com --net=host --name=pgadmin dpage/pgadmin4

Redis
docker run --name redis-server -d --net=host redis redis-server --save 60 1 --loglevel warning