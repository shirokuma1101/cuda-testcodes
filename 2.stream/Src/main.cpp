#include "cpu.h"
#include "cuda.cuh"

template<class T>
constexpr T ToSquare(T n) { return static_cast<T>(std::pow(2.f, n)); }

int main()
{
    //note: https://co-crea.jp/wp-content/uploads/2016/07/File_2.pdf

    /* ===== Init ===== */

    _CrtSetDbgFlag(_CRTDBG_ALLOC_MEM_DF | _CRTDBG_LEAK_CHECK_DF);
    static const int n = ToSquare(16);
    static const int streamNum = 4;
    float type;
    std::cout << typeid(type).name() << " : " << n << std::endl;

    /* ===== CPU ===== */

    Timer cpu_timer;
    cpu_timer.Start();
    auto cpu_ = CPU<decltype(type)>(n, streamNum);
    cpu_.AllocateMemory();
    cpu_timer.End();
    cpu_timer.Show("CPU - allocate memory");

    cpu_timer.Start();
    cpu_.HeavyCalc();
    cpu_timer.End();
    cpu_timer.Show("CPU - calc");


    /* ===== GPU ===== */

    Timer gpu_timer;
    gpu_timer.Start();
    auto gpu_ = GPU<decltype(type)>(n, streamNum);
    gpu_.AllocateMemory();
    gpu_timer.End();
    gpu_timer.Show("GPU - allocate memory");

    gpu_timer.Start();
    gpu_.HeavyCalc();
    gpu_.CopyDstMemory();
    gpu_timer.End();
    gpu_timer.Show("GPU - calc");

    cpu_.CheckIntegrity();
    gpu_.CheckIntegrity();

    /* ===== Release ===== */
}
