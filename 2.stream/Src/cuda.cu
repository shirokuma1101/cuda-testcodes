#include "cuda.cuh"

#define GPU_THREAD_INDEX_X blockIdx.x * blockDim.x + threadIdx.x
#define GPU_THREAD_INDEX_Y blockIdx.y * blockDim.y + threadIdx.y
#define GPU_THREAD_INDEX_Z blockIdx.z * blockDim.z + threadIdx.z

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

    for (auto&& e : streams) {
        auto tmp = GPUStream();
        cudaStreamCreate(&tmp.cudaStream);
        size_t nbytes = e.num * sizeof(T);
        cudaMalloc(&tmp.pDevSrc, nbytes);
        cudaMalloc(&tmp.pDevDst, nbytes);
        cudaMemset(tmp.pDevSrc, 0, nbytes);
        cudaMemcpyAsync(tmp.pDevSrc, e.pSrc, nbytes, cudaMemcpyHostToDevice, tmp.cudaStream);
        gpuStreams.push_back(tmp);
    }
}

template<class T>
void GPU<T>::HeavyCalc()
{
    for (size_t i = 0; i < gpuStreams.size(); ++i) {
        dim3 block(512, 1, 1);
        dim3 grid(streams[i].num / block.x, 1, 1);
        host_to_device<<<grid, block, 0, gpuStreams[i].cudaStream>>>(gpuStreams[i].pDevSrc, gpuStreams[i].pDevDst);
    }
}

template<class T>
void GPU<T>::CopyDstMemory()
{
    for (size_t i = 0; i < gpuStreams.size(); ++i) {
        size_t nbytes = streams[i].num * sizeof(T);
        cudaMemcpyAsync(streams[i].pDst, gpuStreams[i].pDevDst, nbytes, cudaMemcpyDeviceToHost, gpuStreams[i].cudaStream);
    }

    for (auto&& e : gpuStreams) {
        cudaStreamSynchronize(e.cudaStream);
    }
}

template void GPU<float>::AllocateMemory();
template void GPU<double>::AllocateMemory();
template void GPU<float>::HeavyCalc();
template void GPU<double>::HeavyCalc();
template void GPU<float>::CopyDstMemory();
template void GPU<double>::CopyDstMemory();
