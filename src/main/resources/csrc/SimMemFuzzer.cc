#ifndef NO_VPI
#include <vpi_user.h>
#include <svdpi.h>
#endif
#include <stdio.h>
#include <stdint.h>

extern "C" void memfuzz_generate_rs(uint8_t *vec_a_ready, uint8_t *vec_a_valid,
                                    long long *vec_a_address,
                                    uint8_t *vec_a_is_store, int *vec_a_size,
                                    long long *vec_a_data, uint8_t *vec_d_ready,
                                    uint8_t *vec_d_valid,
                                    uint8_t *vec_d_is_store, int *vec_d_size,
                                    uint8_t *finished);

extern "C" void memfuzz_init(int num_lanes) {
  printf("from C: num_lanes=%d\n", num_lanes);
}

extern "C" void memfuzz_generate(uint8_t *vec_a_ready, uint8_t *vec_a_valid,
                                 long long *vec_a_address,
                                 uint8_t *vec_a_is_store, int *vec_a_size,
                                 long long *vec_a_data, uint8_t *vec_d_ready,
                                 uint8_t *vec_d_valid, uint8_t *vec_d_is_store,
                                 int *vec_d_size, uint8_t *finished) {
  memfuzz_generate_rs(vec_a_ready, vec_a_valid, vec_a_address, vec_a_is_store,
                      vec_a_size, vec_a_data, vec_d_ready, vec_d_valid,
                      vec_d_is_store, vec_d_size, finished);
}
