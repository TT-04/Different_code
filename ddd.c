#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define hex_len 16
#define MAX_LEN 1000006

int func(char symbol)
{
    const char hex[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };
    int i = 0;

    for (i = 0; i < hex_len; i++) {
        if (hex[i] == symbol) {
            return i;
        }
    }
    return -1;
}

int main()
{

    char* byte[] = { "0000", "0001", "0010", "0011", "0100", "0101", "0110", "0111", "1000", "1001", "1010", "1011", "1100", "1101", "1110", "1111" };
    char* s;

    s = (char*)malloc(sizeof(char) * MAX_LEN);

    scanf("%s", s);

    int len = strlen(s);

    s = (char*)realloc(s, sizeof(char) * len);

    int flag = 0;
    int i = 0;

    for (i = 0; i < len; i++) {
        if (s[i] != '0') {
            flag = 1;
        }
        else if (flag == 0) {
            continue;
        }
        int hex_index = func(s[i]);
        printf("%s", byte[hex_index]);
    }
    printf("\n");
    free(s);
    return 0;
}
