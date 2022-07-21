#pragma once
#include "base.h"

#include <iostream>

#define GPU_THREAD_INDEX_X blockIdx.x * blockDim.x + threadIdx.x
#define GPU_THREAD_INDEX_Y blockIdx.y * blockDim.y + threadIdx.y
#define GPU_THREAD_INDEX_Z blockIdx.z * blockDim.z + threadIdx.z

template<class T>
class GPU : public HeavyProcess<T> {
public:

	GPU(int n) : HeavyProcess<T>(n) {}
	~GPU() noexcept override {
		cudaFree(pDevSrc);
		cudaFree(pDevDst);
		std::cout << cudaGetErrorString(cudaGetLastError()) << std::endl;
	}

	void AllocateMemory() override;
	void HeavyCalc() override;

	void CopyDstMemory();

private:

	T* pDevSrc = nullptr;
	T* pDevDst = nullptr;

};
