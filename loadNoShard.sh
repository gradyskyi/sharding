whoami

for i in {10..100}; do
  psql -U postgres -d postgres -c "insert into books_no_shard values ($i, 1, 'Pelevin', 'Omon Ra', 1991);"
done