#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1

cat schema.sql | mysql db_hw1

cd dataset/

for f in *.csv; do
echo "Loading $f..."
echo "load data local infile './$f'
into table ${f/.csv/}
fields terminated by ','
enclosed by '\"'
lines terminated by '\n'
ignore 1 lines;" | mysql db_hw1
done
