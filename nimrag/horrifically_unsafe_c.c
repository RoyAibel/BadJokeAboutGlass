#include <stdio.h>
#include <stdlib.h>

const float MAX_GLASS_CAPACITY = 10;

const int THIRSTY = 1;

int intern_counter = 0;

struct intern
{
    int hopes_and_dreams;
};

typedef struct intern m_Intern;

int main(int argc, char const *argv[])
{

    float glass = MAX_GLASS_CAPACITY;

    while (THIRSTY)
    {
        if(glass < 0.5f){

            m_Intern* sacrifice = summonIntern();

            refill(sacrifice, &glass);

        }
        drink(&glass);


    }
    

    return 0;
}

void drink(float *glassptr)
{
    *glassptr -= 1;
}

m_Intern *summonIntern()
{
    m_Intern *fresh_meat;
    fresh_meat = malloc(sizeof(m_Intern));
    fresh_meat->hopes_and_dreams = 100;

    intern_counter++;
    return fresh_meat;
}

void refill(m_Intern *sacrifice, float *glassptr)
{
    sacrifice->hopes_and_dreams = -1;
    free(sacrifice);
    *glassptr = MAX_GLASS_CAPACITY;
    printf("RIP intern %d\n", intern_counter);
}
