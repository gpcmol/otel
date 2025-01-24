## CloudNative Postgres

### Install
kubectl apply --server-side -f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.25/releases/cnpg-1.25.0.yaml

### Install kubectl cnpg plugin
curl -sSfL \
https://github.com/cloudnative-pg/cloudnative-pg/raw/main/hack/install-cnpg-plugin.sh | \
sudo sh -s -- -b /usr/local/bin

### Watch cnpg cluster status
watch -n 5 kubectl cnpg status cluster-example

### Nice to reads
https://www.gabrielebartolini.it/articles/2024/03/cloudnativepg-recipe-1-setting-up-your-local-playground-in-minutes/
https://www.enterprisedb.com/blog/the-dos-donts-postgres-high-availability-part1
https://www.enterprisedb.com/blog/how-cloudnativepg-manages-replication-slots
https://cloudnative-pg.io/documentation/1.25/replication/#capping-the-wal-size-retained-for-replication-slots

### Load on DB using pg bench tool
bash into writer instance:
psql
\list+
create database example;
exit
pgbench -i -s 50 example
pgbench -c 10 -j 2 -t 10000 example
psql
drop database example;
