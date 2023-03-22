#!/usr/bin/env bash
cd "$(basename "$0")" || exit 1

cat schema.sql | mysql db_hw1

cd dataset/

for f  in *.csv; do
echo "load data local infile './$f'
into table ${f/.csv/}
fields terminated by ','
enclosed by '\"'
lines terminated by '\n'
ignore 1 lines;"
done | mysql db_hw1
