#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>

int main(int argc, char** argv) {
    if(argc < 2) {
        perror("Enter file name\n");
        return 1;
    }
    char FileName[strlen(argv[1]) + 1];

    for(int i = 0; i < strlen(argv[1]); i++){
        FileName[i] = argv[1][i];
    }
    FileName[strlen(argv[1])] = '\0';
    printf("%s", FileName);
    size_t fd = open(FileName, O_RDWR);
    char buf[13] = "";

    for(int i = 0;; i++) {
        lseek(fd, i, SEEK_SET);
        if (!read(fd, &buf, sizeof(buf))) {
            break;
        }
        buf[13] = '\0';
        if (strcmp(buf, "Hello world!") == 0) {
            lseek(fd, i, SEEK_SET);
            sprintf(buf, "Sapere aude!");
            write(fd, buf, sizeof(buf) - 1);
            break;
        }
    }

    return 0;
}