#include "hash.h"

hash_entry::hash_entry(int key, int value)
: key(key)
, value(value)
, next(nullptr) {
	printf("hash_entry(key=%d, value=%d)\n", key, value);
}

hash_entry::~hash_entry() {
	if (next != nullptr)
		delete next;
}

hash_bucket::hash_bucket(int hash_key, int depth)
: local_depth(depth)
, num_entries(0)
, hash_key(hash_key)
, first(nullptr) {
	printf("hash_bucket(hash_key=%d, depth=%d)\n", hash_key, depth);
}

/*
 * Free the memory alocated to this->first.
 */
hash_bucket::~hash_bucket() {
	if (first != nullptr)
		delete first;
}

hash_table::hash_table(int table_size, int bucket_size, int num_rows, vector<int> key, vector<int> value)
: table_size(2)
, bucket_size(bucket_size)
, global_depth(1)
, bucket_table(8192, nullptr) {
	assert(table_size == 2);
	bucket_table[2] = new hash_bucket(0, 1);
	bucket_table[3] = new hash_bucket(1, 1);
	for (int i=0; i<num_rows; i++)
		insert(key[i], value[i]);

	puts("bucket table summary:");
	for (int k=0; k<8000; k++)
		if (bucket_table[k] != nullptr) {
			printf("    bucket[%d] (depth=%d, key=%d): ", k, bucket_table[k]->local_depth, bucket_table[k]->hash_key);
			auto ptr = bucket_table[k]->first;
			while (ptr != nullptr) {
				printf("%d, ", ptr->key);
				ptr = ptr->next;
			}
			printf("(%d items)\n", bucket_table[k]->num_entries);
		}
}

/*
 * When insert collide happened, it needs to do rehash and distribute the entries in the bucket.
 * Furthermore, if the global depth equals to the local depth, you need to extend the table size.
 */
void hash_table::extend(int bidx) {
	printf("extend(bidx=%d)\n", bidx);
	int hb = 1 << (31 - __builtin_clz(bidx));
	bucket_table[bidx]->local_depth++;
	bucket_table[bidx + hb*2] = new hash_bucket(bidx + hb, bucket_table[bidx]->local_depth);
	bucket_table[bidx + hb] = bucket_table[bidx];
	bucket_table[bidx] = nullptr;

	hash_entry **ptr0, **ptr1, *ptr, *nxt;
	ptr0 = &bucket_table[bidx + hb]->first;
	ptr1 = &bucket_table[bidx + hb*2]->first;
	ptr = *ptr0;
	while (ptr != nullptr) {
		if (ptr->key & hb) {
			*ptr1 = ptr;
			ptr1 = &(*ptr1)->next;
		} else {
			*ptr0 = ptr;
			ptr0 = &(*ptr0)->next;
		}
		nxt = ptr->next;
		ptr->next = nullptr;
		ptr = nxt;
	}
}

/*
 * When construct hash_table you can call insert() in the for loop for each key-value pair.
 */
void hash_table::insert(int key, int value) {
	int len = 0;
	while (bucket_table[tail(key, len)] == nullptr) len++;
	printf("insert(key=%d, value=%d): %d\n", key, value, tail(key, len));

	hash_entry **ptr = &bucket_table[tail(key, len)]->first;
	while (*ptr != nullptr)
		ptr = &(*ptr)->next;
	*ptr = new hash_entry(key, value);

	if (++bucket_table[tail(key, len)]->num_entries > bucket_size)
		extend(tail(key, len));
}

/*
 * The function might be called when shrink happened.
 * Check whether the table necessory need the current size of table, or half the size of table.
 */
void hash_table::half_table() {
	printf("half_table()\n");
}

/*
 * If a bucket with no entries, it need to check whether the pair hash index bucket 
 * is in the same local depth. If true, then merge the two bucket and reassign all the 
 * related hash index. Or, keep the bucket in the same local depth and wait until the bucket 
 * with pair hash index comes to the same local depth.
 */
void hash_table::shrink(int bidx) {
	printf("shrink(bidx=%d)\n", bidx);
}

/*
 * When executing remove_query you can call remove() in the for loop for each key.
 */
void hash_table::remove(int key) {
	printf("remove(key=%d)\n", key);
}

void hash_table::key_query(vector<int> query_keys, string file_name) {
	printf("key_query(query_keys=%ld, file_name=%s)\n", query_keys.size(), file_name.c_str());
}

void hash_table::remove_query(vector<int> query_keys) {
	printf("remove_query(query_keys=%ld)\n", query_keys.size());
}

/*
 * Free the memory that you have allocated in this program.
 */
void hash_table::clear() {
	printf("hash_table::clear()\n");
	for (auto bucket : bucket_table)
		if (bucket != nullptr) {
			delete bucket;
		}
}
