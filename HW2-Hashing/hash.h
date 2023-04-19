#include <algorithm>
#include <iostream>
#include <cassert>
#include <fstream>
#include <bitset>
#include <string>
#include <vector>
#include <vector>
#include <cmath>
#include "utils.h"

#define tail(key, len) (((key)&((1<<(len))-1)) | 1<<(len))

using namespace std;

class hash_entry {
public:
	int key;
	int value;
	hash_entry *next;  // 以 linked list 結構儲存資料
	hash_entry(int key, int value);

	~hash_entry();
};

class hash_bucket {
public:
	int local_depth;  // 2 進位時目前所數的 bit
	int num_entries;  // 當前所放的 entry 數量
	int hash_key;	 // 紀錄目前的 hash index
	hash_entry* first;  // 所指向的 entry 位址
	hash_bucket(int hash_key, int depth);

	~hash_bucket();
};

class hash_table {
public:
	int table_size;	// 當前 hash index 的數量
	int bucket_size;   // bucket 可放 entry 最大上限
	int global_depth;  // 2 進位時目前所數到的值
	vector<hash_bucket*> bucket_table;  // Binary Tree hash suffix -> hash_bucket
	hash_table(int table_size, int bucket_size, int num_rows, vector<int> key, vector<int> value);

	void extend(int bidx);
	void half_table();
	void shrink(int bidx);
	void insert(int key, int value);
	void remove(int key);

	void key_query(vector<int> query_keys, string file_name);
	void remove_query(vector<int> query_remove_keys);

	void clear();
};
