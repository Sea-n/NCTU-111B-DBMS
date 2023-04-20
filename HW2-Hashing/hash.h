#include "utils.h"

#define tail(key, len) (((key)&((1<<(len))-1)) | 1<<(len))

class hash_entry {
public:
	int key, value;
	hash_entry *next;

	hash_entry(int key, int value);
	~hash_entry();
};

class hash_bucket {
public:
	int local_depth, num_entries, hash_key;
	hash_entry *first;

	hash_bucket(int hash_key, int depth);
	~hash_bucket();
};

class hash_table {
public:
	int table_size, bucket_size, global_depth;
	vector<hash_bucket *> bucket_table;

	hash_table(int table_size, int bucket_size, int num_rows, vector<int> key, vector<int> value);
	void insert(int key, int value);
	void extend(int bidx);
	void key_query(vector<int> query_keys, string file_name);
	void remove_query(vector<int> query_remove_keys);
	void remove(int key);
	void shrink(int bidx);
	void half_table();
	void clear();
};
