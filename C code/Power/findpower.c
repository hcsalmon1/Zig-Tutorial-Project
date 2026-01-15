#include <stdio.h>
int main() 
{
    int base, exp;
    double result = 1.0;
    printf("Enter a base number: ");
    scanf("%d", &base);
    printf("Enter an exponent: ");
    scanf("%d", &exp);

    while (exp != 0) {
        printf("Looping = %.0f\n", result);
        result *= base;
        exp -= 1;
    }

    printf("Answer = %.0f\n", result);
    return 0;
}