#pragma once

struct Timer {
    DWORD start;
    DWORD end;

    Timer() noexcept
        : start(timeGetTime())
        , end(0)
    {}
    void Start() { start = timeGetTime(); }
    void End() { end = timeGetTime(); }
    void Show(std::string str = "duration") {
        std::cout << str << ":" << ((end ? end : timeGetTime()) - start) << "ms." << std::endl;
    }
};
