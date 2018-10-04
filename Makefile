.PHONY: clean run docker singularity run-udocker run-nodocker docker.image
all: run-nodocker
SHELL=bash
RUN := $(PWD)/runs/run_$(shell date +%F-%H-%M-%S)
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

run-udocker: .virtualenv/bin/udocker steps/prepdata.cwl
	mkdir -p $(RUN)
	.virtualenv/bin/cwltool \
		--user-space-docker-cmd `pwd`/.virtualenv/bin/udocker \
		--cachedir cache \
		--outdir $(RUN)/results \
		presto.cwl \
		demo_job.yaml > >(tee $(RUN)/output) 2> >(tee $(RUN)/log >&2)

run: data/$(PULSAR) .virtualenv/bin/cwltool steps/prepdata.cwl
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

toil: data/$(PULSAR) .virtualenv/bin/cwltoil docker.image
	mkdir -p $(RUN)/results
	.virtualenv/bin/toil-cwl-runner \
		--logFile $(RUN)/log \
		--outdir $(RUN)/results \
		--jobStore file://$(RUN)/job_store \
		presto.cwl \
		demo_job.yaml | tee $(RUN)/output

slurm: data/$(PULSAR) .virtualenv/bin/cwltoil
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

docker.image:
	docker build . -t kernsuite/presto

singularity:  .virtualenv/bin/cwltool data/$(PULSAR)
	mkdir -p $(RUN)/results
	.virtualenv/bin/toil-cwl-runner \
		--singularity \
		--logFile $(RUN)/log \
		--outdir $(RUN)/results \
		--jobStore file://$(RUN)/job_store \
		presto.cwl \
		demo_job.yaml | tee $(RUN)/output
