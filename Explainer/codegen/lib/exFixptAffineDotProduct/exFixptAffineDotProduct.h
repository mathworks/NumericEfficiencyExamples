#ifndef EXFIXPTAFFINEDOTPRODUCT_H
#define EXFIXPTAFFINEDOTPRODUCT_H

#include "rtwtypes.h"
#include <stddef.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

extern uint32_T exFixptAffineDotProduct(const uint8_T a[128],
                                        const uint8_T b[128], uint8_T offset);

#ifdef __cplusplus
}
#endif

#endif
