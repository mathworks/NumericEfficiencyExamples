#include "exFixptCastWrapFloor.h"

int8_T exFixptCastWrapFloor(int16_T a)
{
  return (int8_T)((int32_T)a >> 6);
}
