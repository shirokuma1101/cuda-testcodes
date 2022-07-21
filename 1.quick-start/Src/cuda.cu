#include "cuda.cuh"

/* device */
__device__ void device_to_device()
{

}

/* kernel */
template<class T>
__global__ void host_to_device(T* pSrc, T* pDst)
{
	int i = GPU_THREAD_INDEX_X;
	pDst[i] = sin(pSrc[i]) * sin(pSrc[i]) + cos(pSrc[i]) * cos(pSrc[i]);
}

/* default */
__host__ void host_to_host()
{

}

template<class T>
void GPU<T>::AllocateMemory()
{
	HeavyProcess<T>::AllocateMemory();
	size_t nbytes = n * sizeof(T);
	cudaMalloc(&pDevSrc, nbytes);
	cudaMalloc(&pDevDst, nbytes);
	cudaMemset(pDevSrc, 0, nbytes);
	cudaMemset(pDevDst, 0, nbytes);
	cudaMemcpy(pDevSrc, pSrc, nbytes, cudaMemcpyHostToDevice);
	cudaMemcpy(pDevDst, pDst, nbytes, cudaMemcpyHostToDevice);
}

template<class T>
void GPU<T>::HeavyCalc()
{
	dim3 block(128, 1, 1);
	dim3 grid(128, 1, 1);
	host_to_device<<<grid, block, 0>>>(pDevSrc, pDevDst);
}

template<class T>
void GPU<T>::CopyDstMemory()
{
	size_t nbytes = n * sizeof(T);
	cudaMemcpy(pDst, pDevDst, nbytes, cudaMemcpyDeviceToHost);
}

template void GPU<float>::AllocateMemory();
template void GPU<double>::AllocateMemory();
template void GPU<float>::HeavyCalc();
template void GPU<double>::HeavyCalc();
template void GPU<float>::CopyDstMemory();
template void GPU<double>::CopyDstMemory();
