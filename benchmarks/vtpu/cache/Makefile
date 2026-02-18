CC = gcc
CFLAGS = -O2 -Wall -march=native
TARGETS = sequential_access random_access

all: $(TARGETS)

sequential_access: sequential_access.c
	$(CC) $(CFLAGS) -o $@ $<

random_access: random_access.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f $(TARGETS) *.o

run: all
	@echo "=== Sequential Access Baseline ==="
	@perf stat -e L1-dcache-loads,L1-dcache-load-misses,LLC-loads,LLC-load-misses ./sequential_access 2>&1 | tee sequential_results.txt
	@echo ""
	@echo "=== Random Access Baseline ==="
	@perf stat -e L1-dcache-loads,L1-dcache-load-misses,LLC-loads,LLC-load-misses ./random_access 2>&1 | tee random_results.txt

.PHONY: all clean run
