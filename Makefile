
# Makefile for convenience, (doesn't look for command outputs)
.PHONY: all
all: base-image base-notebook pangeo-notebook ml-notebook pangeo-airflow-code

TESTDIR=/srv/test

.PHONY: base-image
base-image :
	cd base-image ; \
	docker build -t pangeo/base-image:master .

.PHONY: base-notebook
base-notebook : base-image
	cd base-notebook ; \
	conda-lock lock --mamba -f environment.yml -p linux-64; \
	../list_packages.sh | sort > packages.txt; \
	docker build -t pangeo/base-notebook:master . ; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) pangeo/base-notebook:master ./run_tests.sh base-notebook

.PHONY: pangeo-notebook
pangeo-notebook : base-image
	cd pangeo-notebook ; \
	conda-lock lock --mamba -f environment.yml -p linux-64; \
	../list_packages.sh | sort > packages.txt; \
	docker build -t pangeo/pangeo-notebook:master . ; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) pangeo/pangeo-notebook:master ./run_tests.sh pangeo-notebook

.PHONY: pangeo-airflow-code
pangeo-airflow-code : base-image
	cd pangeo-airflow-code ; \
	../update_lockfile.sh; \
	../list_packages.sh | sort > packages.txt; \
	docker build -t pangeo/pangeo-airflow-code:master . ; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) pangeo/pangeo-airflow-code:master ./run_tests.sh pangeo-airflow-code

.PHONY: pytorch-airflow-code
pytorch-airflow-code : base-image
	cd pytorch-airflow-code ; \
	../update_lockfile.sh; \
	../list_packages.sh | sort > packages.txt; \
	docker build -t pangeo/pytorch-airflow-code:master . ; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) pangeo/pytorch-airflow-code:master ./run_tests.sh pytorch-airflow-code

.PHONY: ml-notebook
ml-notebook : base-image
	cd ml-notebook ; \
	conda-lock lock --mamba -f environment.yml -f ../pangeo-notebook/environment.yml -p linux-64; \
	../list_packages.sh | sort > packages.txt; \
	docker build -t pangeo/ml-notebook:master . ; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) pangeo/ml-notebook:master ./run_tests.sh ml-notebook
