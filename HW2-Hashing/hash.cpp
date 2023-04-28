/* Author: Sean Wei */
#include "hash.h"
#define IDX (((key)&((1<<(len))-1)) | 1<<(len))
#define BKT bucket_table[IDX]

/* Hash Entry */
hash_entry::hash_entry(const int key, const int value)
: key(key), value(value), next(nullptr) { }

hash_entry::~hash_entry() {
	if (next != nullptr) delete next;
}

/* Hash Bucket */
hash_bucket::hash_bucket(const int hash_key, const int depth)
: local_depth(depth), num_entries(0), hash_key(hash_key), first(nullptr) { }

hash_bucket::~hash_bucket() {
	if (first != nullptr) delete first;
}

/* Hash Table */
hash_table::hash_table(const int table_size, const int bucket_size, const int num_rows, const vector<int> key, const vector<int> value)
: table_size(table_size), bucket_size(bucket_size), global_depth(1), bucket_table(1e7, nullptr) {
	bucket_table[1] = new hash_bucket(0, 0);
	for (int i=0; i<num_rows; i++)
		insert(key[i], value[i]);
}

void hash_table::insert(const int key, const int value) {
	int len = global_depth;  // find the correct local depth
	while (BKT == nullptr) len--;

	hash_entry **ptr = &BKT->first;
	while (*ptr != nullptr && (*ptr)->key != key) ptr = &(*ptr)->next;

	if (*ptr != nullptr) {  // update entry instead of add a duplicated one
		(*ptr)->value = value;
		return;
	}

	*ptr = new hash_entry(key, value);  // Add new entry to the end of the bucket
	if (++BKT->num_entries > bucket_size)
		extend(IDX);
}

void hash_table::extend(const int bidx) {
	const int hb = 1 << (31 - __builtin_clz(bidx));  // Highest bit
	global_depth = max(global_depth, ++bucket_table[bidx]->local_depth);
	bucket_table[bidx + hb*2] = new hash_bucket(bidx, bucket_table[bidx]->local_depth);  // 1xx: new empty bucket
	bucket_table[bidx + hb] = bucket_table[bidx];  // 0xx: copy the origin bucket
	bucket_table[bidx] = nullptr;  // xx: remove old bucket

	hash_entry **b0, **b1, *ptr, *nxt;
	b0 = &bucket_table[bidx + hb]->first;    // linked list of 0xx bucket
	b1 = &bucket_table[bidx + hb*2]->first;  // linked list of 1xx bucket
	ptr = *b0;  // all unsorted entries
	*b0 = nullptr;
	while (ptr != nullptr) {
		nxt = ptr->next;  // check next item
		ptr->next = nullptr;  // for arranged item, make it independent
		if (ptr->key & hb) {
			*b1 = ptr;  // move from 0xx to 1xx bucket
			b1 = &(*b1)->next;
			bucket_table[bidx + hb]->num_entries--;
			bucket_table[bidx + hb*2]->num_entries++;
		} else {
			*b0 = ptr;
			b0 = &(*b0)->next;
		}
		ptr = nxt;
	}

	if (!bucket_table[bidx + hb]->num_entries) extend(bidx + hb*2);
	else if (!bucket_table[bidx + hb*2]->num_entries) extend(bidx + hb);
}

void hash_table::key_query(const vector<int> query_keys, const string file_name) {
	FILE *f = fopen(file_name.c_str(), "w");
	setvbuf(f, NULL, _IOFBF, 1e7);
	for (int key : query_keys) {
		int len = global_depth;  // find the correct local depth
		while (BKT == nullptr) len--;

		hash_entry *ptr = BKT->first;
		while (ptr != nullptr) {
			if (ptr->key == key) {
				fprintf(f, "%d,%d\n", ptr->value, len);
				break;
			}
			ptr = ptr->next;
		}
		if (ptr == nullptr)  // not found
			fprintf(f, "-1,%d\n", len);
	}
	fclose(f);
}

void hash_table::remove_query(const vector<int> query_keys) {
	for (const int key : query_keys)
		remove(key);
	for (int k=9e6; k>0; k--)
		if (bucket_table[k] != nullptr && !bucket_table[k]->num_entries)
			shrink(k);
	half_table();
}

void hash_table::remove(const int key) {
	int len = global_depth;  // find the correct local depth
	while (BKT == nullptr) len--;

	hash_entry *prev, *ptr;
	prev = BKT->first;
	if (prev == nullptr) return;  // empty bucket
	if (prev->key == key) {  // special case: item is the first one
		ptr = BKT->first;
		BKT->first = ptr->next;
		goto rm_fin;
	}

	while (prev->next != nullptr && prev->next->key != key) prev = prev->next;
	if (prev->next == nullptr) return;  // not found

	ptr = prev->next;
	prev->next = ptr->next;  // concat previous and next entry

rm_fin:  // common ending for both case
	BKT->num_entries--;
	ptr->next = nullptr;
	delete ptr;
}

void hash_table::shrink(const int bidx) {
	if (bidx <= 1) return;  // prefix = 0 bit
	const int hb = 1 << (30 - __builtin_clz(bidx));  // Highest bit (new)
	if (bucket_table[bidx ^ hb] == nullptr) return;  // paired bucket is splitted

	bucket_table[bidx ^ hb]->local_depth--;
	bucket_table[bidx ^ hb]->hash_key &= ~hb;
	bucket_table[hb + (bidx & (hb-1))] = bucket_table[bidx ^ hb];  // move bxx to xx
	bucket_table[bidx ^ hb] = nullptr;  // bxx: remove old bucket
	delete bucket_table[bidx];
	bucket_table[bidx] = nullptr;  // axx: remove empty bucket
}

void hash_table::half_table() {
	for (int k=(1<<global_depth); k<(2<<global_depth); k++)
		if (bucket_table[k] != nullptr) return;
	global_depth--;
	half_table();  // Check again
}

void hash_table::clear() {
	for (auto bucket : bucket_table)
		if (bucket != nullptr) delete bucket;
}
