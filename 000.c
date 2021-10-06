#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>

int i;
int main(int argc, char* argv[]) {
	if (argc < 2){
		printf("Error!\n");
	return 1;           
 }
size_t fd = open(argv[1], O_RDWR);
char buf[13] = "";
for (i = 0;;i++){
	lseek(fd, i, SEEK_SET);
	if (!read(fd, &buf, sizeof(buf))) {
		break;
	}
	if (strcmp(buf, "Hello world!") == 0) {
		 lseek(fd, i, SEEK_SET);
		 sprintf(buf, "Sapere aude!");
		 write(fd, buf, sizeof(buf));
		 break;
	}
}
close(fd);
return 0;
}
