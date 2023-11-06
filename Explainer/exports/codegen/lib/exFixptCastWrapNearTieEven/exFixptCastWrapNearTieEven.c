#include "exFixptCastWrapNearTieEven.h"

int8_T exFixptCastWrapNearTieEven(int16_T a)
{
  return (int8_T)((((int32_T)a >> 6) +
                   ((((int32_T)a & 32) != 0) && (((int32_T)a & 31) != 0))) +
                  ((((int32_T)a & 63) == 32) && (((int32_T)a & 64) != 0)));
}
