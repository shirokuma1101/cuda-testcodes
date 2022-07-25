#pragma once

#include <iostream>

#include "base.h"

template<class T>
class GPU : public HeavyProcess<T> {
public:

	GPU(int n, int stream_num) noexcept
		: HeavyProcess<T>(n, stream_num)
	{}
	~GPU() noexcept override {
		Release();
	}

	void AllocateMemory() override;
	void HeavyCalc() override;

	void CopyDstMemory();

private:

	struct GPUStream {
		T*           pDevSrc;
		T*           pDevDst;
		cudaStream_t cudaStream;
	};

	std::vector<GPUStream> gpuStreams;

	void Release() {
		for (auto&& e : gpuStreams) {
			cudaStreamDestroy(e.cudaStream);
			cudaFree(e.pDevSrc);
			cudaFree(e.pDevDst);
		}
		std::cout << cudaGetErrorString(cudaGetLastError()) << std::endl;
		gpuStreams.clear();
	}

};
