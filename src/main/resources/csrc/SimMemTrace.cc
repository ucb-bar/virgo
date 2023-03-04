#include <vpi_user.h>
#include <svdpi.h>
#include <memory>
#include <string>
#include <fstream>
#include <cstdio>
#include <unistd.h>

class MemTraceReader;

// Global singleton instance of MemTraceReader
static std::unique_ptr<MemTraceReader> reader;

struct MemTraceLine {
  bool valid = false;
  unsigned long cycle = 0;
  char loadstore[10];
  int core_id = 0;
  int thread_id = 0;
  unsigned long address = 0;
  unsigned long data = 0;
  int data_size = 0;
};

class MemTraceReader {
public:
  MemTraceReader(const std::string &filename) {
    char cwd[4096];
    if (getcwd(cwd, sizeof(cwd))) {
        printf("MemTraceReader: current working dir: %s\n", cwd);
    }

    infile.open(filename);
    if (infile.fail()) {
        fprintf(stderr, "failed to open file %s\n", filename);
    }
  }
  ~MemTraceReader() {
    infile.close();
    printf("MemTraceReader destroyed\n");
  }
  MemTraceLine tick();

  std::ifstream infile;
};

MemTraceLine MemTraceReader::tick() {
  MemTraceLine line;

  printf("MemTraceReader: started parsing\n");

  while (infile >> line.cycle >> line.loadstore >> line.core_id >>
         line.thread_id >> std::hex >> line.address >> line.data >> std::dec >>
         line.data_size) {
    line.valid = true;
    trace.push_back(line);
  }
  read_pos = trace.cbegin();

  printf("MemTraceReader: finished parsing\n");
}

// Try to read a memory request that might have happened at a given cycle, on a
// given SIMD lane (= "thread").  In case no request happened at that point,
// return an empty line with .valid = false.
MemTraceLine MemTraceReader::read_trace_at(const long cycle,
                                           const int thread_id) {
  MemTraceLine line;
  line.valid = false;

  printf("tick(): cycle=%ld\n", cycle);

  if (finished()) {
    return line;
  }

  line = *read_pos;
  // It should always be guaranteed that we consumed all of the past lines, and
  // the next line is in the future.
  if (line.cycle < cycle) {
    fprintf(stderr, "line.cycle=%ld, cycle=%ld\n", line.cycle, cycle);
    assert(false && "some trace lines are left unread in the past");
  }

  if (line.cycle > cycle) {
    // We haven't reached the cycle mark specified in this line yet, so we don't
    // read it right now.
    return MemTraceLine{};
  } else if (line.cycle == cycle) {
    printf("fire! cycle=%ld, valid=%d\n", cycle, line.valid);
    // FIXME! Currently thread_id is assumed to be in round-robin order, e.g.
    // 0->1->2->3->0->..., both in the trace file and the order the caller calls
    // this function.  If this is not true, we cannot simply monotonically
    // increment read_pos.
    ++read_pos;
  }

  return line;
}

extern "C" void memtrace_init(const char *filename) {
  reader = std::make_unique<MemTraceReader>(filename);
  printf("memtrace_init: filename=[%s]\n", filename);
}

// TODO: accept core_id as well
extern "C" void memtrace_query(unsigned char trace_read_ready,
                               unsigned long trace_read_cycle,
                               int trace_read_thread_id,
                               unsigned char *trace_read_valid,
                               unsigned long *trace_read_address,
                               unsigned char *trace_read_finished) {
  printf("memtrace_query(cycle=%ld, tid=%d)\n", trace_read_cycle,
         trace_read_thread_id);

  *trace_read_valid = line.valid;
  *trace_read_cycle = line.cycle;
  *trace_read_address = line.address;

  return;
}
