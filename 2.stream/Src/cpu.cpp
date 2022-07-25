#include "cpu.h"

template<class T>
void CPU<T>::HeavyCalc()
{
    for (auto&& e : this->streams) {
        for (int i = 0; i < e.num; ++i) {
            e.pDst[i]
                = std::sin(e.pSrc[i]) * std::sin(e.pSrc[i])
                + std::cos(e.pSrc[i]) * std::cos(e.pSrc[i]);
        }
    }
}

template void CPU<float>::HeavyCalc();
template void CPU<double>::HeavyCalc();
