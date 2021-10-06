nclude <stdio.h>
#include <unistd.h> 
#include <fcntl.h>
#include <string>

int main(int argc, char* argv[]) {
	    if (argc < 2) {
		            perror("Enter file name\n");
			            return 1;
				        }
	        
	      	size_t fd = open(argv[1], O_RDWR)
			    char buf[12] = "";

		    for (int i = 0;; i++) {
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
		      	clo return 0;
}

