#include "exFixptCast.h"
#include "exFixptCast_types.h"

static int8_T castSatCeil(int16_T a);

static int8_T castSatFloor(int16_T a);

static int8_T castSatNearTieAway(int16_T a);

static int8_T castSatNearTieEven(int16_T a);

static int8_T castSatNearTieInf(int16_T a);

static int8_T castSatZero(int16_T a);

static int8_T castWrapCeil(int16_T a);

static int8_T castWrapFloor(int16_T a);

static int8_T castWrapNearTieAway(int16_T a);

static int8_T castWrapNearTieEven(int16_T a);

static int8_T castWrapNearTieInf(int16_T a);

static int8_T castWrapZero(int16_T a);

static int8_T castSatCeil(int16_T a)
{
  int16_T i;
  i = (int16_T)(((int32_T)a + 127) >> 7);
  if ((int32_T)i > 127) {
    i = (int16_T)127;
  } else if ((int32_T)i < -128) {
    i = (int16_T)-128;
  }
  return (int8_T)i;
}

static int8_T castSatFloor(int16_T a)
{
  int16_T i;
  i = (int16_T)((int32_T)a >> 7);
  if ((int32_T)i > 127) {
    i = (int16_T)127;
  } else if ((int32_T)i < -128) {
    i = (int16_T)-128;
  }
  return (int8_T)i;
}

static int8_T castSatNearTieAway(int16_T a)
{
  int16_T i;
  i = (int16_T)(((int32_T)a >> 7) +
                ((((int32_T)a & 64) != 0) &&
                 ((((int32_T)a & 63) != 0) || ((int32_T)a > 0))));
  if ((int32_T)i > 127) {
    i = (int16_T)127;
  } else if ((int32_T)i < -128) {
    i = (int16_T)-128;
  }
  return (int8_T)i;
}

static int8_T castSatNearTieEven(int16_T a)
{
  int16_T i;
  i = (int16_T)((((int32_T)a >> 7) +
                 ((((int32_T)a & 64) != 0) && (((int32_T)a & 63) != 0))) +
                ((((int32_T)a & 127) == 64) && (((int32_T)a & 128) != 0)));
  if ((int32_T)i > 127) {
    i = (int16_T)127;
  } else if ((int32_T)i < -128) {
    i = (int16_T)-128;
  }
  return (int8_T)i;
}

static int8_T castSatNearTieInf(int16_T a)
{
  int16_T i;
  i = (int16_T)(((int32_T)a + 64) >> 7);
  if ((int32_T)i > 127) {
    i = (int16_T)127;
  } else if ((int32_T)i < -128) {
    i = (int16_T)-128;
  }
  return (int8_T)i;
}

static int8_T castSatZero(int16_T a)
{
  int32_T i;
  int16_T i1;
  if ((int32_T)a < 0) {
    i = 127;
  } else {
    i = 0;
  }
  i1 = (int16_T)((int32_T)(int16_T)((int32_T)a + i) >> 7);
  if ((int32_T)i1 > 127) {
    i1 = (int16_T)127;
  } else if ((int32_T)i1 < -128) {
    i1 = (int16_T)-128;
  }
  return (int8_T)i1;
}

static int8_T castWrapCeil(int16_T a)
{
  return (int8_T)(((int32_T)a + 127) >> 7);
}

static int8_T castWrapFloor(int16_T a)
{
  return (int8_T)((int32_T)a >> 7);
}

static int8_T castWrapNearTieAway(int16_T a)
{
  return (int8_T)(((int32_T)a >> 7) +
                  ((((int32_T)a & 64) != 0) &&
                   ((((int32_T)a & 63) != 0) || ((int32_T)a > 0))));
}

static int8_T castWrapNearTieEven(int16_T a)
{
  return (int8_T)((((int32_T)a >> 7) +
                   ((((int32_T)a & 64) != 0) && (((int32_T)a & 63) != 0))) +
                  ((((int32_T)a & 127) == 64) && (((int32_T)a & 128) != 0)));
}

static int8_T castWrapNearTieInf(int16_T a)
{
  return (int8_T)(((int32_T)a + 64) >> 7);
}

static int8_T castWrapZero(int16_T a)
{
  int32_T i;
  if ((int32_T)a < 0) {
    i = 127;
  } else {
    i = 0;
  }
  return (int8_T)((int32_T)(int16_T)((int32_T)a + i) >> 7);
}

void exFixptCast(int16_T a, struct0_T *r)
{
  r->yWrapFloor = castWrapFloor(a);
  r->yWrapZero = castWrapZero(a);
  r->yWrapCeil = castWrapCeil(a);
  r->yWrapNearTieInf = castWrapNearTieInf(a);
  r->yWrapNearTieAway = castWrapNearTieAway(a);
  r->yWrapNearTieEven = castWrapNearTieEven(a);
  r->ySatFloor = castSatFloor(a);
  r->ySatZero = castSatZero(a);
  r->ySatCeil = castSatCeil(a);
  r->ySatNearTieInf = castSatNearTieInf(a);
  r->ySatNearTieAway = castSatNearTieAway(a);
  r->ySatNearTieEven = castSatNearTieEven(a);
}
