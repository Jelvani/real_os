/*
The Real_OS kernel starts at 0x120:0x0. No modification of 
segments will take place in this operating system. Therefore,
all memory addresses are releative to 0x120. Physical address is 
calculated by PA = 0x120 * 0x10 + VA. 
*/

asm (".pushsection .text.bootstrap\n\t"
     "jmp kmain\n\t"
     ".popsection");
     
asm(".include \"src/functions.s\"");
#include <stddef.h>
#include <stdint.h>
#pragma GCC diagnostic ignored "-Wunused-variable"


typedef enum {BLACK = 0x0,
            BLUE,
            GREEN,
            CYAN,
            RED,
            MAGENTA,
            BROWN,
            LGRAY,
            DGRAY,
            LBLUE,
            LGREEN,
            LCYAN,
            LRED,
            LMAGENTA,
            YELLOW,
            WHITE} color_t;


int print(char* str);
int cls();
int setbgr(color_t color);

int kmain(){
    char* a = "Welcome to my Real-OS\n\r"; //string must have carriage return: \r

    color_t clr = RED;
    cls();
    setbgr(clr);
    print(a);
    cls();
    while(1){
        for(int i = BLACK; i<= WHITE; i++){
            setbgr(i);
            for(int j =0; j< 100000000; j++){
                asm("nop");
            }
        }

        
    }
    
    //print(a);
    
    return 0;
}


int print(char* str){
    
    if(str==NULL) return -1;

    //extended inline assembly
    asm ("mov esi, %0" //gcc gnu assembler only works with 32bit registers
         :
         :"r"(str) 
         :"esi"        
         ); 
    
    asm("call print_string");

    return 0;
}

int cls(){

    asm("call clear_screen");
    asm("call reset_cursor");
    return 0;
}

//set background color, clears screen
int setbgr(color_t color){

    asm ("mov bl, %0"
         :
         :"r"((uint8_t) color) 
         :"bl"        
         );

    asm("call set_background");
    return 0;
}