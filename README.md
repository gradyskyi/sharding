# sharding

`docker-compose up`

load shard:

`time docker exec --user postgres -i shard_master bash -c "psql -U postgres -d postgres < dump.sql"`

`time docker exec --user postgres -i shard_master bash -c "./loadShard.sh"`

load non shard:

`time docker exec --user postgres -i shard_master bash -c "psql -U postgres -d postgres < dumpNoShard.sql"`

`time docker exec --user postgres -i shard_master bash -c "./loadNoShard.sh"`