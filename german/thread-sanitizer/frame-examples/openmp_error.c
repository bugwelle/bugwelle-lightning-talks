#include <stdio.h>
#include <omp.h>

#define N 10000

int main (int argc, char **argv)
{
    int a[N];
    int j = N;
    // [...] initialisiere array
    #pragma omp parallel for
    for (int i = 0; i < N - 2; i++) {
        #pragma omp critical
        a[i] = a[i] + a[j];
        j--;
    }
}
