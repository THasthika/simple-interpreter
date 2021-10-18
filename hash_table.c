#include "hash_table.h"
#include "linked_list.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define P 67

int hash_func(HashTable* table, char *key) {
    int hash = 0;
    int l = strlen(key);
    int k = 0;
    for (int i = 0; i < l; i++) {
        
        k = 0;
        if (key[i] >= 'a' && key[i] <= 'z') {
            k = key[i] - 'a';
        } else if (key[i] >= 'A' && key[i] <= 'Z') {
            k = (key[i] - 'A') + ('z' - 'a' + 1);
        } else if (key[i] >= '0' && key[i] <= '9') {
            k = (key[i] - '0') + ('z' - 'a' + 1) + ('Z' - 'A' + 1);
        }

        hash = (P * hash + k) % table->size;
    }

    return hash;
}

void hash_table_create(HashTable** table, size_t size) {
    *table = malloc(sizeof(HashTable));
    (*table)->size = size;
    (*table)->lists = malloc(sizeof(LinkedList*)*size);
    for (size_t i = 0; i < size; i++) {
        linked_list_create(&(*table)->lists[i]);
    }
}

void hash_table_destroy(HashTable* table) {
    for (int i = 0; i < table->size; i++) {
        linked_list_destroy(table->lists[i]);
    }
    free(table);
}

int hash_table_add(HashTable* table, char* key, double data) {

    int loc = hash_func(table, key);

    HashTableItem item;
    item.data = data;

    // get slot
    LinkedList* l = table->lists[loc];
    if (linked_list_insert(l, key, &item, sizeof(HashTableItem)) == 0) {
        return 0;
    }

    return 1;
}

int hash_table_remove(HashTable* table, char* key, double* data) {

    // get hash loc
    int loc = hash_func(table, key);

    LinkedList* list = table->lists[loc];

    HashTableItem item;

    // get item
    if (linked_list_remove(list, key, &item) == 0) {
        return 0;
    }

    if (data != NULL) {
        // copy data
        *data = item.data;
    }

    return 1;
}

int hash_table_replace(HashTable* table, char* key, double data) {
    // get hash loc
    int loc = hash_func(table, key);

    LinkedList* list = table->lists[loc];
    LinkedListItem* listItem;

    if (linked_list_lookup_item(list, key, &listItem) == 0) {
        return 0;
    }

    HashTableItem* item = (HashTableItem*) listItem->data;

    item->data = data;

    return 1;
}

int hash_table_lookup(HashTable* table, char* key, double* data) {

    // get hash loc
    int loc = hash_func(table, key);

    LinkedList* list = table->lists[loc];
    LinkedListItem* listItem;

    if (linked_list_lookup_item(list, key, &listItem) == 0) {
        return 0;
    }

    HashTableItem* item = (HashTableItem*) listItem->data;

    *data = item->data;

    return 1;
}

int hash_table_lookup_item(HashTable* table, char* key, HashTableItem** item) {
    // get hash loc
    int loc = hash_func(table, key);

    LinkedList* list = table->lists[loc];
    LinkedListItem* listItem;

    if (linked_list_lookup_item(list, key, &listItem) == 0) {
        return 0;
    }

    *item = (HashTableItem*) listItem->data;
    return 1;
}