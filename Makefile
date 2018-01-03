TARGET=mandelbrot
OBJS=mandelbrot.o
LINK=$(CXX)
CXXFLAGS=-pipe -Wall -O3  -fomit-frame-pointer -march=native -mfpmath=sse -msse2 -fopenmp   -mno-fma --std=c++14
LDFLAGS=-fopenmp

.PHONY: all
all: $(TARGET) 

.PHONY: clean
clean:
	$(RM) $(TARGET) $(OBJS)

.PHONY: test
test: $(TARGET)
	@echo TESTING...
	@EXPECTED=cc65e64bd553ed18896de1dfe7fae3e5 \
		&& OUTPUT=$$($(PWD)/$(TARGET) 200 | md5sum -b | cut -d' ' -f1) \
		&& echo "EXPECTED: $$EXPECTED" \
		&& echo "  OUTPUT: $$OUTPUT" \
		&& [ "$$EXPECTED" = "$$OUTPUT" ]
	@echo SUCCESS!

.PHONY: benchmark
benchmark: $(TARGET)
	@time $(PWD)/$(TARGET) > /dev/null

$(TARGET): $(OBJS)
	$(LINK) $(LDFLAGS) -o $@ $^
