#pragma once

template<class T>
class HeavyProcess {
public:

    HeavyProcess(int n) : n(n) {};
    virtual ~HeavyProcess() noexcept { Release(); }

    virtual void AllocateMemory() {
        this->pSrc = new T[this->n]{};
        this->pDst = new T[this->n]{};
    }
    virtual void HeavyCalc() = 0;
    void CheckIntegrity() {
        assert(CheckSum());
    }

protected:

    const int n;
    T* pSrc = nullptr;
    T* pDst = nullptr;

private:

    void SafeArrayDelete(T* p) {
        if (!p) return;
        delete[] p;
        p = nullptr;
    }

    void Release() {
        SafeArrayDelete(pSrc);
        SafeArrayDelete(pDst);
    }

    bool CheckSum() {
        int sum = 0;
        for (int i = 0; i < n; ++i) {
            sum += (int)pDst[i];
        }
        return sum == n;
    }

};
