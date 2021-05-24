#include <stdint.h>

int main(){
    __asm__ ("int $0x10\n\t"
            :
            : "a"(((uint16_t)0x0e << 8) | 'a'),
              "b"(0x0000));
    return 0;
}