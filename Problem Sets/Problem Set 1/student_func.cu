// Homework 1
// Color to Greyscale Conversion

//A common way to represent color images is known as RGBA - the color
//is specified by how much Red, Grean and Blue is in it.
//The 'A' stands for Alpha and is used for transparency, it will bed
//ignored in this homework.

//Each channel Red, Blue, Green and Alpha is represented by one byte.
//Since we are using one byte for each color there are 256 different
//possible values for each color.  This means we use 4 bytes per pixel.

//Greyscale images are represented by a single intensity value per pixel
//which is one byte in size.

//To convert an image from color to grayscale one simple method is to
//set the intensity to the average of the RGB channels.  But we will
//use a more sophisticated method that takes into account how the eye 
//perceives color and weights the channels unequally.

//The eye responds most strongly to green followed by red and then blue.
//The NTSC (National Television System Committee) recommends the following
//formula for color to greyscale conversion:

//I = .299f * R + .587f * G + .114f * B

//Notice the trailing f's on the numbers which indicate that they are 
//single precision floating point constants and not double precision
//constants.

//You should fill in the kernel as well as set the block and grid sizes
//so that the entire image is processed.

#include "utils.h"

__global__
void rgba_to_greyscale(const uchar4* const rgbaImage,
                       unsigned char* const greyImage,
                       int numRows, int numCols)
{
  //Fill in the kernel to convert from color to greyscale
  //the mapping from components of a uchar4 to RGBA is:
  // .x -> R ; .y -> G ; .z -> B ; .w -> A
  //
  //The output (greyImage) at each pixel should be the result of
  //applying the formula: output = .299f * R + .587f * G + .114f * B;
  //Note: We will be ignoring the alpha channel for this conversion
  int x = blockDim.x * blockIdx.x + threadIdx.x;
  int y = blockDim.y * blockIdx.y + threadIdx.y;
  // printf("blockDim.x %d blockIdx.x %d threadIdx.x %d x:%d \n", blockDim.x, blockIdx.x, threadIdx.x, x);
  if ( x < numCols && y < numRows)
  {
    int offset = y * numCols + x;
    greyImage[offset] = .299f * rgbaImage[offset].x + .587f * rgbaImage[offset].y + .114f * rgbaImage[offset].z ;
    // printf("offset %d\n",offset);
    // printf("R:%d\n",int(0.299f * rgbaImage[offset].x));
    // printf("G:%d\n",0.587f * rgbaImage[offset].y);
    // printf("B:%d\n",0.114f * rgbaImage[offset].z);
    // printf("R: %d G: %d B: %d\n",rgbaImage[offset].x,rgbaImage[offset].y,rgbaImage[offset].z);
    
  }

}

void your_rgba_to_greyscale(const uchar4 * const h_rgbaImage, uchar4 * const d_rgbaImage,
                            unsigned char* const d_greyImage, size_t numRows, size_t numCols)
{
  //You must fill in the correct sizes for the blockSize and gridSize
  //currently only one block with one thread is being launched
  const dim3 blockSize(32, 16, 1);
  const dim3 gridSize(1 + (numCols / blockSize.x),
                      1 + (numRows / blockSize.y),
                      1);
  rgba_to_greyscale<<<gridSize, blockSize>>>(d_rgbaImage, d_greyImage, numRows, numCols);
  // printf("cuda last error:%d\n",cudaGetLastError());
  
  cudaDeviceSynchronize(); checkCudaErrors(cudaGetLastError());

}
