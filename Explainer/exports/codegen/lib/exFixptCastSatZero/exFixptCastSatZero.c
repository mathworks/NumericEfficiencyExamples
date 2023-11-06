#include "exFixptCastSatZero.h"

int8_T exFixptCastSatZero(int16_T a)
{
  int32_T i;
  int16_T i1;
  if ((int32_T)a < 0) {
    i = 63;
  } else {
    i = 0;
  }
  i1 = (int16_T)((int32_T)(int16_T)((int32_T)a + i) >> 6);
  if ((int32_T)i1 > 127) {
    i1 = (int16_T)127;
  } else if ((int32_T)i1 < -128) {
    i1 = (int16_T)-128;
  }
  return (int8_T)i1;
}
