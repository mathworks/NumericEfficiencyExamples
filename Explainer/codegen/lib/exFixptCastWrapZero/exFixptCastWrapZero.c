#include "exFixptCastWrapZero.h"

int8_T exFixptCastWrapZero(int16_T a)
{
  int32_T i;
  if ((int32_T)a < 0) {
    i = 63;
  } else {
    i = 0;
  }
  return (int8_T)((int32_T)(int16_T)((int32_T)a + i) >> 6);
}
