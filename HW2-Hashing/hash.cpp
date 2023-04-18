#include "hash.h"

hash_entry::hash_entry(int key, int value) {
	printf("hash_entry(key=%d, value=%d)\n", key, value);
}

hash_bucket::hash_bucket(int hash_key, int depth) {
	printf("has_bucket(hash_key=%d, depth=%d)\n", hash_key, depth);
}

/*
 * Free the memory alocated to this->first.
 */
void hash_bucket::clear() {
    printf("clear()\n");
}

hash_table::hash_table(int table_size, int bucket_size, int num_rows, vector<int> key, vector<int> value) {
    printf("hash_table(table_size=%d, bucket_size=%d, num_rows=%d, key[0]=%d, value[0]=%d)\n", table_size, bucket_size, num_rows, key[0], value[0]);
}

/*
 * When insert collide happened, it needs to do rehash and distribute the entries in the bucket.
 * Furthermore, if the global depth equals to the local depth, you need to extend the table size.
 */
void hash_table::extend(hash_bucket *bucket) {

}

/*
 * When construct hash_table you can call insert() in the for loop for each key-value pair.
 */
void hash_table::insert(int key, int value) {
    
}

/*
 * The function might be called when shrink happened.
 * Check whether the table necessory need the current size of table, or half the size of table.
 */
void hash_table::half_table() {
    
}

/*
 * If a bucket with no entries, it need to check whether the pair hash index bucket 
 * is in the same local depth. If true, then merge the two bucket and reassign all the 
 * related hash index. Or, keep the bucket in the same local depth and wait until the bucket 
 * with pair hash index comes to the same local depth.
 */
void hash_table::shrink(hash_bucket *bucket) {

}

/*
 * When executing remove_query you can call remove() in the for loop for each key.
 */
void hash_table::remove(int key) {

}

void hash_table::key_query(vector<int> query_keys, string file_name) {
    
}

void hash_table::remove_query(vector<int> query_keys) {
    
}

/*
 * Free the memory that you have allocated in this program.
 */
void hash_table::clear() {

}
