#pragma once

#include "base.h"

template<class T>
class CPU : public HeavyProcess<T> {
public:

    CPU(int n, int stream_num) noexcept
        : HeavyProcess<T>(n, stream_num)
    {}

    void HeavyCalc() override;

};
