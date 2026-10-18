#include <stdio.h>

extern int verificaMatrice(int mat[][4], int dim);

int main (){
    int mat[4][4] = {{1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}};
    
    int dim = 4;
    
    int a = verificaMatrice(mat, dim);
    printf ("%d\n", a);
    return 0;
}