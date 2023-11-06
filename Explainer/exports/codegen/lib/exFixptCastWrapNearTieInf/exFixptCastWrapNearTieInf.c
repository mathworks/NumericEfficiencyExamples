#include "exFixptCastWrapNearTieInf.h"

int8_T exFixptCastWrapNearTieInf(int16_T a)
{
  return (int8_T)(((int32_T)a + 32) >> 6);
}
