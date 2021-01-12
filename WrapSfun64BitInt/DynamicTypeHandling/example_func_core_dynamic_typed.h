
#ifndef DEF_FUNC_CORE_DYNAMIC_ADD
#define DEF_FUNC_CORE_DYNAMIC_ADD

/* Fixed width integer types from C99 standard */
#include <stdint.h>
//#include<stdbool.h>

/* Type attributes descriptor struct 
 *
 * For C using struct.  If C++ consider creating a class. 
 */
typedef struct _numTypeAttrib
{
    uint8_t isFloat;
    uint8_t isSigned;
    uint32_t wordLength;
} numTypeAttrib;

void func_core_hybrid_add_dispatch(
    void const *const pU0,
    void const *const pU1,
    void *const pY0,
    numTypeAttrib const *const pNtAttribU0,
    numTypeAttrib const *const pNtAttribU1,
    numTypeAttrib const *const pNtAttribY0);

#endif
