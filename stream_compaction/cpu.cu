#include <cstdio>
#include "cpu.h"

#include "common.h"

namespace StreamCompaction {
    namespace CPU {
        using StreamCompaction::Common::PerformanceTimer;
        PerformanceTimer& timer()
        {
            static PerformanceTimer timer;
            return timer;
        }

        /**
         * CPU scan (prefix sum).
         * For performance analysis, this is supposed to be a simple for loop.
         * (Optional) For better understanding before starting moving to GPU, you can simulate your GPU scan in this function first.
         */
        void scan(int n, int *odata, const int *idata) {
            timer().startCpuTimer();
            // TODO
            odata[0] = 0;
            for (int i = 1; i < n; ++i)
            {
                odata[i] = odata[i - 1] + idata[i - 1];
            }
            timer().endCpuTimer();
        }

        /**
         * CPU stream compaction without using the scan function.
         *
         * @returns the number of elements remaining after compaction.
         */
        int compactWithoutScan(int n, int *odata, const int *idata) {
            timer().startCpuTimer();
            // TODO
            int currentOutputIndex = 0;
            for (int i = 0; i < n; ++i)
            {
                if (idata[i] != 0)
                {
                    odata[currentOutputIndex] = idata[i];
                    currentOutputIndex++;
                }
            }
            timer().endCpuTimer();
            return currentOutputIndex;
        }

        /**
         * CPU stream compaction using scan and scatter, like the parallel version.
         *
         * @returns the number of elements remaining after compaction.
         */
        int compactWithScan(int n, int *odata, const int *idata) {
            int* mapData = new int[n];
            int* scanData = new int[n];

            timer().startCpuTimer();
            // TODO
            for (int i = 0; i < n; ++i)
            {
                if (idata[i] != 0)
                {
                    mapData[i] = 1;
                }
                else
                {
                    mapData[i] = 0;
                }
            }

            // scan(n, scanData, mapData); this will throw an exception for re-start the cpu timer
            scanData[0] = 0;
            for (int i = 1; i < n; ++i)
            {
                scanData[i] = scanData[i - 1] + mapData[i - 1];
            }


            for (int i = 0; i < n; i++)
            {
                if (idata[i] !=0)
                {
                    odata[scanData[i]] = idata[i];
                }
            }

            int result = scanData[n - 1];
            timer().endCpuTimer();
            delete[] mapData;
            delete[] scanData;
            return result;
        }
    }
}
