
start only db: docker-compose -f docker-compose.onlyDB.yml up
activate virtualenv:
linux - source venv/bin/activate
windows - venv\Scripts\activate

run using docker:
 docker-compose up
 or
 docker-compose up --build

 run localy:
 set FLASK_ENV=development
 set FLASK_DEBUG=1


docker ps
docker exec -it 06c8ce5158f8 /bin/ash # connect to alpine container
docker exec -it 06c8ce5158f8 bash # connect to postgres container