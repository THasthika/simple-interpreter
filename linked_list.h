#if !defined(LINKED_LIST_H)
#define LINKED_LIST_H

/**
 * 
 * Linked list implementation for the hash map
 * 
 * */

typedef struct linked_list_item {
    void* key;
    void* data;
    size_t data_size;
    struct linked_list_item* next;
} LinkedListItem;

typedef struct linked_list {
    int count;
    LinkedListItem* head;
} LinkedList;

void linked_list_create(LinkedList** list);
void linked_list_destroy(LinkedList* list);

int linked_list_lookup_item(LinkedList* list, char* key, LinkedListItem** item);

int linked_list_insert(LinkedList* list, char* key, void* data, size_t data_size);
int linked_list_remove(LinkedList* list, char* key, void* data);
int linked_list_lookup(LinkedList* list, char* key, void* data);


#endif // LINKED_LIST_H
