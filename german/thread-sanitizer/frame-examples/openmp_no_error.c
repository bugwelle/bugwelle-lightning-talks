#include <stdio.h>
#include <omp.h>

int main () {
    int i = 0;
    #pragma omp parallel
    {
        #pragma omp critical
        {
            ++i;
        }
    }
    printf("Ausgabe: %d\n", i);
    return i;
}
