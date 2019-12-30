The functions in this folder make it easy to cast from built-in MATLAB integers to their equivalent 
fi objects and back in the other direction.

   castIntToFi
   
   castFiToInt
   
   cast64BitIntToFi
   
   cast64BitFiToInt

These functions are especially useful for dealing with input and output signals inside MATLAB Function Block,
Stateflow MATLAB action language, and MATLAB System Block.

These functions also make it easier to deal with pending R2020a changes 
to handling of 64 bit integer inside MATLAB Function Block and MATLAB System Block.

Functions by the same names will ship with R2020a.
In R2020a and newer, you should use the shipping versions.
To use the shim versions in this folder, in R2019b and older, 
simply put this folder on your MATLAB path. 

Availabily of these shims for older releases allow you to use the same models across older and newer releases.

Consider an example usage.
The default behavior is that Simulink signals of type uint8, int8, uint16, int16, uint32, and int32
come into a MATLAB Function block as the MATLAB built-in integer version.
But if your code is designed to deal with fi objects, then the MATLAB built-in integer can make your code
behave incorrectly. By simply inserting a call

   u = castIntToFi(uOriginal);

all built-in integers will be replaced by their fi equivalents. And all other types will pass through unchanged.
For example, doubles, singles, logicals, and fi objects will pass through unchanged. This makes it easier to
write polymorphic code.
   
In R2020a, Simulink signals of type 64 bit integer types will also come into MATLAB Function block and 
MATLAB System Block as the MATLAB built-in integer version. Prior to R2020a, the default was for these to
types to come in as fi objects. To maintain that old behavior, you could simple insert either of these two calls.

u = castIntToFi(uOriginal);

or

u = cast64BitIntToFi(uOriginal);
