dtra.tater.io:
  container_name: dtra.tater.io
  image: docker-repository.tater.io:5000/apps/tater
  ports:
    - "8001:3000"
  restart: always
  environment:
    - MONGO_URL=mongodb://10.0.0.92:27017/dtra
    - ROOT_URL=https://dtra.tater.io
    - PORT=3000
    - DISABLE_WEBSOCKETS=TRUE


