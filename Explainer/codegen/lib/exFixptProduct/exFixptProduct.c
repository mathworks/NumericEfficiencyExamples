#include "exFixptProduct.h"

int8_T exFixptProduct(int8_T a, int8_T b)
{
  return (int8_T)(((int32_T)a * (int32_T)b) >> 8);
}
