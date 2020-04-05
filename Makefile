NAME := Vector ML Project
DESC := A streaming platform for AI services

.PHONY: install test clean

install:
	cd fmnist && pip install -e .
test: install
	pytest
clean:

