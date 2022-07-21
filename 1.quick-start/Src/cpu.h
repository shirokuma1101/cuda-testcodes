#pragma once
#include "base.h"

template<class T>
class CPU : public HeavyProcess<T> {
public:

	CPU(int n) : HeavyProcess<T>(n) {}

	void HeavyCalc() override;

};
