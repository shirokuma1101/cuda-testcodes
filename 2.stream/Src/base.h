#pragma once

#include <cassert>
#include <vector>

template<class T>
class HeavyProcess {
public:

    HeavyProcess(int n, int stream_num) noexcept
        : n(n)
        , streamNum(stream_num)
    {}
    virtual ~HeavyProcess() noexcept {
        Release();
    }

    virtual void AllocateMemory() {
        int surplus   = n / streamNum;
        int remainder = n % streamNum;

        for (int i = 0; i < streamNum; ++i) {
            auto tmp_stream = Stream<T>();
            if (remainder && i == streamNum - 1) {
                tmp_stream.num = surplus + remainder;
                tmp_stream.pSrc = new T[surplus + remainder]{};
                tmp_stream.pDst = new T[surplus + remainder]{};
            }
            else {
                tmp_stream.num = surplus;
                tmp_stream.pSrc = new T[surplus]{};
                tmp_stream.pDst = new T[surplus]{};
            }
            streams.push_back(tmp_stream);
        }
    }

    virtual void HeavyCalc() = 0;

    void CheckIntegrity() {
        assert(CheckSum());
    }

protected:

    template<class T>
    struct Stream {
        int num;
        T*  pSrc;
        T*  pDst;
    };

    const int              n;
    const int              streamNum;
    std::vector<Stream<T>> streams;


private:

    void SafeArrayDelete(T* p) {
        if (!p) return;
        delete[] p;
        p = nullptr;
    }

    void Release() {
        for (const auto& e : streams) {
            SafeArrayDelete(e.pSrc);
            SafeArrayDelete(e.pDst);
        }
    }

    bool CheckSum() const {
        int sum = 0;
        for (const auto& e : streams) {
            for (int i = 0; i < e.num; ++i) {
                sum += (int)e.pDst[i];
            }
        }
        return sum == n;
    }

};
