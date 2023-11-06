#include "exFixptCastSatFloor.h"

int8_T exFixptCastSatFloor(int16_T a)
{
  int16_T i;
  i = (int16_T)((int32_T)a >> 6);
  if ((int32_T)i > 127) {
    i = (int16_T)127;
  } else if ((int32_T)i < -128) {
    i = (int16_T)-128;
  }
  return (int8_T)i;
}
