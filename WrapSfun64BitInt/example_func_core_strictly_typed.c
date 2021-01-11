
/* Fixed width integer types from C99 standard */
#include <stdint.h>

#include "example_func_core_strictly_typed.h"

uint64_t func_core_hybrid_add(uint64_t const a, uint32_t const b)
{
    uint64_t c;
    c = a + ((uint64_t)b);
    return c;
}
