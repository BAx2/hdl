/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include <stdint.h>
#include "platform.h"
#include "xil_printf.h"
#include <assert.h>

#define BASE_PUF_ADDR 0x43c10000

typedef uint32_t  u32;

int main()
{
    init_platform();

    volatile u32 *core_magic = BASE_PUF_ADDR + 0x08;
    volatile u32 *seed       = BASE_PUF_ADDR + 0x0c;
    volatile u32 *poly       = BASE_PUF_ADDR + 0x10;
    volatile u32 *cont       = BASE_PUF_ADDR + 0x14;
    volatile u32 *status     = BASE_PUF_ADDR + 0x1c;
    volatile u32 *Q          = BASE_PUF_ADDR + 0x18;

    if (*core_magic == 0x47465550) // PUFG
    {
    	*seed = 1;
    	*poly = 0x8c000001;
    	*cont = 26;
    	//*cont = 0xffffffff;
    	*status = 0xff; // write transaction initiate transfer

    	while( (*status & 0x8) != 0 );

    	xil_printf("\n\n SEED: %d, POLY: 0x%08X, Q:0x%08X \n\n", *seed, *poly, *Q);
    	assert(*Q == 0x07ffffff);
    }

    cleanup_platform();
    return 0;
}
