#include "exFixptCastSatNearTieEven.h"

int8_T exFixptCastSatNearTieEven(int16_T a)
{
  int16_T i;
  i = (int16_T)((((int32_T)a >> 6) +
                 ((((int32_T)a & 32) != 0) && (((int32_T)a & 31) != 0))) +
                ((((int32_T)a & 63) == 32) && (((int32_T)a & 64) != 0)));
  if ((int32_T)i > 127) {
    i = (int16_T)127;
  } else if ((int32_T)i < -128) {
    i = (int16_T)-128;
  }
  return (int8_T)i;
}
