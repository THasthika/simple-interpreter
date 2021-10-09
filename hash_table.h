#if !defined(HASH_TABLE_H)
#define HASH_TABLE_H

#define TYPE_INTEGER 1
#define TYPE_FLOAT 2

#include <stdlib.h>
#include "linked_list.h"

/**
 * 
 * A hash table implementation to store (INTEGER, FLOAT)
 * 
 */

typedef struct hash_table_item
{
    void* data;
    int type;
} HashTableItem;

typedef struct hash_table
{
    size_t size;
    LinkedList** lists;
} HashTable;

void hash_table_create(HashTable** table, size_t size);
void hash_table_destroy(HashTable* table);

int hash_table_add(HashTable* table, char* key, void* data, int type);
int hash_table_remove(HashTable* table, char* key, void* data);

int hash_table_replace(HashTable* table, char* key, void* data, int type);
int hash_table_lookup(HashTable* table, char* key, void* data, int* type);

int hash_table_lookup_item(HashTable* table, char* key, HashTableItem** item);


#endif // HASH_TABLE_H