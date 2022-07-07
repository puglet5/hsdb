## ITMO Heritage Lab DB app (Heritage Science Database)

Export appropriate database env variables (see config/database.yml)

Install docker, docker-compose and run:

```bash
git clone https://github.com/puglet5/hsdb.git
cd hsdb/
docker-compose build && docker-compose up
```
---

If you get the following error: `Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock`, execute:
```bash
sudo chmod 666 /var/run/docker.sock
```
