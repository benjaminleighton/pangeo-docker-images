# Makefile for convenience
.PHONY: base-image base-notebook pangeo-notebook pangeo-airflow-code ml-notebook 
TESTDIR=/srv/test

base-image :
	cd base-image ; \
	docker build -t pangeo/base-image:master .

base-notebook : base-image
	cd base-notebook ; \
	../update_lockfile.sh; \
	../list_packages.sh | sort > packages.txt; \
	docker build -t pangeo/base-notebook:master . ; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) pangeo/base-notebook:master ./run_tests.sh base-notebook

pangeo-notebook : base-image
	cd pangeo-notebook ; \
	../update_lockfile.sh; \
	../list_packages.sh | sort > packages.txt; \
	docker build -t pangeo/pangeo-notebook:master . ; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) pangeo/pangeo-notebook:master ./run_tests.sh pangeo-notebook

pangeo-airflow-code : base-image
	cd pangeo-airflow-code ; \
	../update_lockfile.sh; \
	../list_packages.sh | sort > packages.txt; \
	docker build -t pangeo/pangeo-airflow-code:master . ; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) pangeo/pangeo-airflow-code:master ./run_tests.sh pangeo-airflow-code

ml-notebook : base-image
	cd ml-notebook ; \
	../update_lockfile.sh condarc.yml; \
	../list_packages.sh | sort > packages.txt; \
	docker build -t pangeo/ml-notebook:master . ; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) pangeo/ml-notebook:master ./run_tests.sh ml-notebook
