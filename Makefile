.PHONY: clean run docker
all: run-nodocker
SHELL=bash
RUN := $(shell pwd)/runs/run_$(shell date +%F-%H-%M-%S)

ARCHIVE=ftp://ftp.astron.nl/outgoing/EOSC/datasets/
PULSAR=GBT_Lband_PSR.fil

.virtualenv/:
	virtualenv -p python2 .virtualenv
 
.virtualenv/bin/cwltool: .virtualenv/
	.virtualenv/bin/pip install -r requirements.txt

.virtualenv/bin/cwltoil: .virtualenv/
	.virtualenv/bin/pip install -r requirements.txt

.virtualenv/bin/udocker: .virtualenv/
	curl https://raw.githubusercontent.com/indigo-dc/udocker/master/udocker.py > .virtualenv/bin/udocker
	chmod u+rx .virtualenv/bin/udocker
	.virtualenv/bin/udocker install

data/$(PULSAR):
	cd data && wget $(ARCHIVE)$(PULSAR)

run-udocker: .virtualenv/bin/udocker
	mkdir -p $(RUN)
	.virtualenv/bin/cwltool \
		--user-space-docker-cmd `pwd`/.virtualenv/bin/udocker \
		--cachedir cache \
		--outdir $(RUN)/results \
		presto.cwl \
		demo_job.yaml > >(tee $(RUN)/output) 2> >(tee $(RUN)/log >&2)

run: data/$(PULSAR) .virtualenv/bin/cwltool
	mkdir -p $(RUN)
	.virtualenv/bin/cwltool \
		--cachedir cache \
		--outdir $(RUN)/results \
		--tmpdir-prefix `pwd`/tmp/ \
		presto.cwl \
		demo_job.yaml > >(tee $(RUN)/output) 2> >(tee $(RUN)/log >&2)

run-nodocker: data/$(PULSAR) .virtualenv/bin/cwltool
	mkdir -p $(RUN)
	.virtualenv/bin/cwltool \
		--no-container \
		--cachedir cache \
		--outdir $(RUN)/results \
		--tmpdir-prefix $(PWD)/tmp/ \
		--leave-tmpdir \
		presto.cwl \
		demo_job.yaml > >(tee $(RUN)/output) 2> >(tee $(RUN)/log >&2)

toil: data/$(PULSAR) .virtualenv/bin/cwltoil
	mkdir -p $(RUN)/results
	.virtualenv/bin/toil-cwl-runner \
		--no-container \
		--logFile $(RUN)/log \
		--outdir $(RUN)/results \
		--jobStore file://$(RUN)/job_store \
		presto.cwl \
		demo_job.yaml | tee $(RUN)/output

slurm: data/$(PULSAR) .virtualenv/bin/cwltoil presto.simg
	mkdir -p $(RUN)/results
	.virtualenv/bin/toil-cwl-runner \
		--batchSystem=slurm \
		--preserve-environment PATH \
		--no-container \
		--logFile $(RUN)/log \
		--outdir $(RUN)/results \
		--jobStore file://$(RUN)/job_store \
		presto.cwl \
		demo_job.yaml | tee $(RUN)/output


docker:
	docker build . -t kernsuite/presto

presto.simg:
	    singularity build presto.simg docker://kernsuite/presto

readfile: docker data/$(PULSAR)
	docker run -v `pwd`:/code:ro kernsuite/presto readfile data/GBT_Lband_PSR.fil

rfifind: docker data/$(PULSAR)
	docker run -v `pwd`:/code:rw kernsuite/presto rfifind -time 2.0 -o Lband data/GBT_Lband_PSR.fil
