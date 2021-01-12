#include "example_func_core_dynamic_typed.h"

uint64_t func_core_hybrid_add(uint64_t const a, uint32_t const b)
{
    uint64_t c;
    c = a + ((uint64_t)b);
    return c;
}

uint64_t func_core_homogeneous_u64_add(uint64_t const a, uint64_t const b)
{
    uint64_t c;
    c = a + b;
    return c;
}

float func_core_homogeneous_f32_add(float const a, float const b)
{
    float c;
    c = a + b;
    return c;
}

void func_core_hybrid_add_dispatch(
    void const *const pU0,
    void const *const pU1,
    void *const pY0,
    numTypeAttrib const *const pNtAttribU0,
    numTypeAttrib const *const pNtAttribU1,
    numTypeAttrib const *const pNtAttribY0)
{
    /* based on attributes of the three numeric type 
     * dispatch to the correct function
     */

    if (
        !pNtAttribU0->isFloat &&
        !pNtAttribU1->isFloat &&
        !pNtAttribY0->isFloat)
    {
        /* Handle integer only cases
        */
        if (
            pNtAttribU0->wordLength == 64 &&
            pNtAttribU1->wordLength == 32 &&
            pNtAttribY0->wordLength == 64)
        {
            uint64_t const *const pU0t = (uint64_t const *const)pU0;
            uint32_t const *const pU1t = (uint32_t const *const)pU1;
            uint64_t *const pY0t = (uint64_t *const)pY0;

            *pY0t = func_core_hybrid_add(*pU0t, *pU1t);
        }
        else if (
            pNtAttribU0->wordLength == 64 &&
            pNtAttribU1->wordLength == 64 &&
            pNtAttribY0->wordLength == 64)
        {
            uint64_t const *const pU0t = (uint64_t const *const)pU0;
            uint64_t const *const pU1t = (uint64_t const *const)pU1;
            uint64_t *const pY0t = (uint64_t *const)pY0;

            *pY0t = func_core_homogeneous_u64_add(*pU0t, *pU1t);
        }
        else
        {
            /* Should not be here.
             * Early error checks should have prevented this.
             */
        }
    }
    else if (
        pNtAttribU0->isFloat &&
        pNtAttribU1->isFloat &&
        pNtAttribY0->isFloat)
    {
        /* Handle floating-poing only cases
        */
        if (
            pNtAttribU0->wordLength == 32 &&
            pNtAttribU1->wordLength == 32 &&
            pNtAttribY0->wordLength == 32)
        {
            /* all 32-bit floating-point singles
             */
            float const *const pU0t = (float const *const)pU0;
            float const *const pU1t = (float const *const)pU1;
            float *const pY0t = (float *const)pY0;

            *pY0t = func_core_homogeneous_f32_add(*pU0t, *pU1t);
        }
        else
        {
            /* Should not be here.
             * Early error checks should have prevented this.
             */
        }
    }
}
