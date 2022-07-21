#include "cpu.h"

template<class T>
void CPU<T>::HeavyCalc()
{
	for (int i = 0; i < this->n; i++) {
		this->pDst[i]
			= sin(this->pSrc[i]) * sin(this->pSrc[i])
			+ cos(this->pSrc[i]) * cos(this->pSrc[i]);
	}
}

template void CPU<float>::HeavyCalc();
template void CPU<double>::HeavyCalc();
