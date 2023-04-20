#include "utils.h"

class hash_entry {
public:
	const int key, value;
	hash_entry *next;

	hash_entry(const int key, const int value);
	~hash_entry();
};

class hash_bucket {
public:
	int local_depth, num_entries, hash_key;
	hash_entry *first;

	hash_bucket(const int hash_key, const int depth);
	~hash_bucket();
};

class hash_table {
public:
	int table_size, bucket_size, global_depth;
	vector<hash_bucket *> bucket_table;

	hash_table(const int table_size, const int bucket_size, const int num_rows, const vector<int> key, const vector<int> value);
	void insert(const int key, const int value);
	void extend(const int bidx);
	void key_query(const vector<int> query_keys, const string file_name);
	void remove_query(const vector<int> query_remove_keys);
	void remove(const int key);
	void shrink(const int bidx);
	void half_table();
	void clear();
};
