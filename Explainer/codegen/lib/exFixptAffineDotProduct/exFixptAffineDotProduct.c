#include "exFixptAffineDotProduct.h"

uint32_T exFixptAffineDotProduct(const uint8_T a[128], const uint8_T b[128],
                                 uint8_T offset)
{
  int32_T i;
  uint32_T y;
  y = (uint32_T)offset << 5;
  for (i = 0; i < 128; i++) {
    y += (uint32_T)a[i] * (uint32_T)(int32_T)b[i];
  }
  return y;
}
