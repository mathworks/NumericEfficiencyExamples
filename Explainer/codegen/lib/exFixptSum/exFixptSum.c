#include "exFixptSum.h"

int16_T exFixptSum(int8_T a, int8_T b)
{
  return (int16_T)(((int32_T)a << 5) + (int32_T)b);
}
