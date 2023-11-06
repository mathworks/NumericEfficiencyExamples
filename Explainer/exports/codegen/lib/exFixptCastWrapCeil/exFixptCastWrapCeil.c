#include "exFixptCastWrapCeil.h"

int8_T exFixptCastWrapCeil(int16_T a)
{
  return (int8_T)(((int32_T)a + 63) >> 6);
}
