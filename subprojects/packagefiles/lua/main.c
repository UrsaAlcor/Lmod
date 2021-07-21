#include <string.h>

extern int main_lua(int argc, char* argv[]);
extern int main_luac(int argc, char* argv[]);

int main(int argc, char* argv[]){
    char* p;

    if(argc<=0 || !argv[0] || !*argv[0])
        return 1;

    p = strrchr(argv[0], '/');
    p = p ? p+1 : argv[0];
    return (strncmp(p, "luac", 4) ? main_lua : main_luac)(argc, argv);
}
