#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include "linked_list.h"

int linked_list_comp(char* a, char* b) {
    return strcmp(a, b);
}

void linked_list_create(LinkedList** list) {
    *list = (LinkedList*) malloc(sizeof(LinkedList));
}

void linked_list_destroy(LinkedList* list) {
    LinkedListItem* n = list->head;
    LinkedListItem* t;

    while (n != NULL) {
        t = n->next;
        free(n->key);
        free(n->data);
        free(n);
        n = t;
    }

    if (list == NULL) {
        return;
    }
    free(list);
}

int linked_list_insert(LinkedList* list, char* key, void* data, size_t data_size) {

    LinkedListItem* n = list->head;

    if (n != NULL) {
        if (linked_list_comp(n->key, key) == 0) {
            return 0;
        }
        while (n->next != NULL) {
            if (linked_list_comp(n->key, key) == 0) {
                return 0;
            }
            n = n->next;
        }
    }

    LinkedListItem* item = (LinkedListItem*) malloc(sizeof(LinkedListItem));

    item->data = malloc(data_size);
    memcpy(item->data, data, data_size);
    item->data_size = data_size;
    item->key = strdup(key);

    if (n == NULL) {
        list->head = item;
    } else {
        n->next = item;
    }

    list->count++;

    return 1;
}

int linked_list_remove(LinkedList* list, char* key, void* data) {
    LinkedListItem* n = list->head;
    LinkedListItem* p = NULL;

    while (n != NULL && linked_list_comp(n->key, key) != 0) {
        p = n;
        n = n->next;
    }

    if (n == NULL) {
        return 0;
    }

    // data = n->data;
    if (data != NULL) {
        memcpy(data, n->data, n->data_size);
    }

    if (p == NULL) {
        list->head = n->next;
    } else {
        p->next = n->next;
    }

    free(n->data);
    free(n->key);
    free(n);

    list->count--;

    return 1;
}

int linked_list_lookup(LinkedList* list, char* key, void* data) {
    LinkedListItem* n = list->head;
    while (n != NULL && linked_list_comp(n->key, key) != 0) {
        n = n->next;
    }

    if (n == NULL) {
        return 0;
    }

    if (data != NULL) {
        memcpy(data, n->data, n->data_size);
    }

    return 1;
}

int linked_list_lookup_item(LinkedList* list, char* key, LinkedListItem** item) {
    LinkedListItem* n = list->head;
    while (n != NULL && linked_list_comp(n->key, key) != 0) {
        n = n->next;
    }

    if (n == NULL) {
        return 0;
    }

    *item = n;
    return 1;
}