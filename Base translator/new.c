/*
File: new.c
File description: Common handy tool. Base translator via command line.

Compilation example in Ubuntu: gcc new.c -o translate

Execution example: ./translate -h
Created by: HecGL
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define INFO "more"



/*FUNCTION TO TRANSLATE FROM FANTASY (8 bits) TO DECIMAL (range 0-2)*/
float fantodec(double num){
	return (num/128.0);
}
	/*FUNTION TO TRANSLATE FROM DECIMAL (range 0-2) TO FANTASY(Fixed point).*/
int dectofan(double num){
	return num*128;
}
 	/*PREVIOUS FUNCTION TO TRANSLATE TO BIN. Not used because of overflow errors, except on fantasy, where there is no overflow because of the small range*/
long int int2bin(long int num){
	return (num == 0 || num == 1 ? num : ((num % 2) + 10 * int2bin(num / 2)));
}
	/*NEW FUNCTION TO TRANSLATE TO BINARY. LESS PROBABILITY OF OVERFLOW AS WE DONT STORE THE NUMBER*/
void int2bin2(long int num){
	if(num==0||num==1) {
		printf("%d", (int)num);
	} else {
		int2bin2(num/2);
		printf("%d", (int)(num%2));
	}
}
	/*PREVIOUS FUNCTION TO PASS TO FANTASY. NOT WORKING. UNUSED*/
/*int dectofan(double num){
	double num2 = num;
	int f,i;
	double aux=0;
	for (i=7, f=0;i>=0;i--){
		aux = num2-((1<<i)/128.0);
		if(aux>=0){
			num2=aux;
			f|=(i<<i);
		}		
	}
	return f;
}*/


int main(int argc, char *argv[]){
	if(argc==1){
		printf("\n\nWrong command or arguments. Try \"%s -h\" or \"%s help\"\n\n",argv[0],argv[0]);
		return 0;
	}
	if ((argc==2)&& ((strcmp(argv[1],"-h")||(strcmp(argv[1],"help"))))){
		printf("\n\t ____                   _______                  _       _\n");
		printf("\t|  _ \\                 |__   __|                | |     | |\n");
		printf("\t| |_) | __ _ ___  ___     | |_ __ __ _ _ __  ___| | __ _| |_ ___  _ __\n ");
		printf("\t|  _ < / _` / __|/ _ \\    | | '__/ _` | '_ \\/ __| |/ _` | __/ _ \\| '__|\n");
		printf("\t| |_) | (_| \\__ \\  __/    | | | | (_| | | | \\__ \\ | (_| | || (_) | |\n");
		printf("\t|____/ \\__,_|___/\\___|    |_|_|  \\__,_|_| |_|___/_|\\__,_|\\__\\___/|_|   \n");
		printf("   ---------------------------------------------------------------------------------\n\n");
		printf("First need input base and output base formula as input2output. Then, number to translate.\n");
		printf("Use only capital or lowercase.\n");
		printf("Input base and output base values can be:\n \tdec,DEC, bin, BIN, oct, OCT, hex, HEX. \n\tInput and output base cant be the same.\n\n");
		printf("For fantasy base of UVACHEDELE, type FAN or fan. Range of decimal from 0 to 2. FAN has 8 bits.\n");
		printf("If you want more info after translating, add \"more\" to the command.\n");
		printf("When a wrong number is tried to translate, the output number will be zero (0). \n\n");
		printf("Examples:\n");
		printf("\t\"%s dec2hex 111\"\t ---Converts from DEC to HEX 111. Output should be 6F.\n",argv[0]);
		printf("\t\"%s hex2dec aaa\"\t ---Converts from HEX to DEC 111. Output should be 2730.\n",argv[0]);
		printf("\t\"%s dec2oct 123\"\t ---Converts from DEC to OCT 123. Output should be 173.\n",argv[0]);
		printf("\t\"%s oct2dec 123\"\t ---Converts from OCT to DEC 123. Output should be 83.\n",argv[0]);
		/*printf("\n\nNote: when translating to bin, because of overflow it only can reach a number up to 1023 (in decimal), 3FF (in hexadecimal) and 1777 (in octal).\nStill trying to solve...");*/
		printf("\n\n");
		printf("Created by HecGL.\n");
		
	}
	else{
		if(!strcmp("dec2hex",argv[1])||(!strcmp("DEC2HEX", argv[1]))){
			if((argc==4) && (!strcmp(INFO, argv[3]))){
			printf("Converted DEC to HEX %X\n",atoi(argv[2]));
			}
			else printf("%X\n",atoi(argv[2]));
		}
		else if((!strcmp("hex2dec", argv[1]))||(!strcmp("HEX2DEC", argv[1]))){
			if((argc==4) && (!strcmp(INFO, argv[3]))){
			printf("Converted HEX to DEC %ld\n",strtol(argv[2], NULL, 16));
			}
			else printf("%ld\n",strtol(argv[2], NULL, 16));
		}
		else if(!strcmp("oct2dec", argv[1])||(!strcmp("OCT2DEC", argv[1]))){
			if((argc==4) && (!strcmp(INFO, argv[3]))){
			printf("Converted OCT to DEC %ld\n",strtol(argv[2], NULL, 8));
			}
			else printf("%ld\n",strtol(argv[2], NULL, 8));
		}
		else if(!strcmp("dec2oct", argv[1])||(!strcmp("DEC2OCT", argv[1]))){
			if((argc==4) && (!strcmp(INFO, argv[3]))){
			printf("Converted DEC to OCT %o\n",atoi(argv[2]));
			}
			else printf("%o\n",atoi(argv[2]));
		}
		else if(!strcmp("oct2hex", argv[1])||(!strcmp("OCT2HEX", argv[1]))){
			if((argc==4) && (!strcmp(INFO, argv[3]))){
			printf("Converted OCT to HEX %X\n",strtol(argv[2], NULL, 8));
			}
			else printf("%X\n",strtol(argv[2], NULL, 8));
		}
		else if(!strcmp("hex2oct", argv[1])||(!strcmp("HEX2OCT", argv[1]))){
			if((argc==4) && (!strcmp(INFO, argv[3]))){
			printf("Converted HEX to OCT %o\n",strtol(argv[2], NULL, 16));
			}
			else printf("%o\n",strtol(argv[2], NULL, 16));
		}
		else if(!strcmp("dec2bin",argv[1])||(!strcmp("DEC2BIN", argv[1]))){
			if((argc==4) && (!strcmp(INFO, argv[3]))){
			printf("Converted DEC to BIN ");
			int2bin2(atoi(argv[2]));
			printf("\n");
			}
			else{				
				/*printf("%ld\n",int2bin(atoi(argv[2])));*/
				int2bin2(atoi(argv[2]));
				printf("\n");
			}
		}
		else if(!strcmp("bin2dec", argv[1])||(!strcmp("BIN2DEC", argv[1]))){
			if((argc==4) && (!strcmp(INFO, argv[3]))){
			printf("Converted BIN to DEC %ld\n",strtol(argv[2], NULL, 2));
			}
			else printf("%ld\n",strtol(argv[2], NULL, 2));
		}
		else if(!strcmp("bin2oct", argv[1])||(!strcmp("BIN2OCT", argv[1]))){
			if((argc==4) && (!strcmp(INFO, argv[3]))){
			printf("Converted BIN to OCT %o\n",strtol(argv[2], NULL, 2));
			}
			else printf("%o\n",strtol(argv[2], NULL, 2));
		}
		else if(!strcmp("oct2bin",argv[1])||(!strcmp("OCT2BIN", argv[1]))){
			if((argc==4) && (!strcmp(INFO, argv[3]))){
			printf("Converted OCT to BIN ");
			int2bin2(strtol(argv[2], NULL, 8));
			printf("\n");
			}
			else {
				/*printf("%ld\n",int2bin(strtol(argv[2], NULL, 8)));*/
				int2bin2(strtol(argv[2], NULL, 8));
				printf("\n");
			}
		}
		else if(!strcmp("bin2hex", argv[1])||(!strcmp("BIN2HEX", argv[1]))){
			if((argc==4) && (!strcmp(INFO, argv[3]))){
			printf("Converted BIN to HEX %X\n",strtol(argv[2], NULL, 2));
			}
			else printf("%X\n",strtol(argv[2], NULL, 2));
		}
		else if(!strcmp("hex2bin",argv[1])||(!strcmp("HEX2BIN", argv[1]))){
			if((argc==4) && (!strcmp(INFO, argv[3]))){
			printf("Converted HEX to BIN ");
			}
			else{
				/*printf("%ld\n",int2bin(strtol(argv[2], NULL, 16)));*/
				int2bin2(strtol(argv[2], NULL, 16));
				printf("\n");
			}
		}
		else if(!strcmp("fan2dec",argv[1])||(!strcmp("FAN2DEC", argv[1]))){
			if((argc==4) && (!strcmp(INFO, argv[3]))){
				printf("Converted FAN to DEC %f\n",fantodec(strtol(argv[2], NULL, 2)));
			}
			else printf("%f\n",fantodec(strtol(argv[2], NULL, 2)));
		}
		else if(!strcmp("dec2fan",argv[1])||(!strcmp("DEC2FAN", argv[1]))){
			if((argc==4) && (!strcmp(INFO, argv[3]))){
				printf("Converted DEC to FAN %08d\n",int2bin(dectofan(atof(argv[2]))));
			}
			else printf("%08d\n",int2bin(dectofan(atof(argv[2]))));
		}
		else{
			printf("\n\nWrong command or arguments. Try \"%s -h\" or \"%s help\"\n\n",argv[0],argv[0]);
		}
	}
	return 0;
}
