# Simulations

The file contains the source code for all the components of our decompressor with 4 different test benches, screenshots for waveforms and output buffer for each screen is also in the file.

## Test Bench 1

First test is a general case of input with different number of match length and literal length

| Label                     | Data                                                                                                  |
| ------------------------- | ----------------------------------------------------------------------------------------------------- |
| Compressed input (HEX)    | 10 31 0100 10 32 0100 10 33 0100  00 0e00 10 31 0e00 10 32 0e00 02 0f00 03 0200 50 31 3131 3131 00 00 |
| Compressed input (DEC)    | 16 49 1 0 16 50 1 0 16 51 1 0 0 14 0 16 49 14 0 16 50 14 0 2 15 0 3 2 0 80 49 49 49 49 49 0 0         |
| Decompressed output (DEC) | 11111 22222 33333 1111 12222 23333 311111 1111111 11111                                               |

## Test Bench 2

| Label                     | Data                                                                            |
| ------------------------- | ------------------------------------------------------------------------------- |
| Compressed input (HEX)    | 10 31 010010 32 0100 10 33 0100 00 0e00  b0 31 3232 3232 3233 3333 3333 0000    |
| Compressed input (DEC)    | 16 49 1 0 16 50 1 0 16 51  1 0 0  14 0 176 49 50 50 50 50 50 51 51 51 51 51 0 0 |
| Decompressed output (DEC) | 11111 22222 33333 1111 12222 23333 311111 1111111 11111                         |

## Test Bench 3

This tests the decompressor when an additonal byte exists for match length

| Label                     | Data                                |
| ------------------------- | ----------------------------------- |
| Compressed input (HEX)    | 1f 31 0100 01  50 3131 3131 31      |
| Compressed input (DEC)    | 31 49  1 0  1 80 49 49 49 49 49 0 0 |
| Decompressed output (DEC) | 1 11111 11111 11111 11111 11111     |

## Test Bench 4

This test the decompressor when an additonal byte exists for literal length

| Label                     | Data                                                     |
| ------------------------- | -------------------------------------------------------- |
| Compressed input (HEX)    | f0 02 3031 3233 3435 3637 3839 6162 6364 6566 67 00      |
| Compressed input (DEC)    | 240  2 4849 5051 5253 5455 5657 9798 99100 101102 103 00 |
| Decompressed output (DEC) | 01 23 45 67 89 ab cd ef g                                |