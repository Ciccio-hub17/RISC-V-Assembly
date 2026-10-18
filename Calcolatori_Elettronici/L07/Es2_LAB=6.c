#include <stdio.h>

extern int numSoluzioniReali(int a, int b, int c);

int main (){
    int a, b, c, d;
    printf("Dammi tre numeri separati da spazi");
    scanf("%d %d %d", &a, &b, &c);
    d = numSoluzioniReali(a, b, c);
    printf("%d", d);
    return 0;
}