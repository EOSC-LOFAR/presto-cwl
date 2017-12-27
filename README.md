# presto-cwl
CWL pipeline for presto

This is a CWL version of the workflow described in the PRESTO tutotial:

http://www.cv.nrao.edu/~sransom/PRESTO_search_tutorial.pdf

Note that this project is still very much in alpha stage and very much in flux.

# requirements

* [Docker](https://www.docker.com/)
* A [CWL](http://www.commonwl.org/) runner (like [CWLtool](https://github.com/common-workflow-language/cwltool))
# usage

# preperations

You first need to preprocess the CWL files since the standard
doesn't support Singularity yet. If you want to use singularity run:

```bash
$ make singularity
```

otherwise run:
```bash
$ make no-singularity
```

On cartesius initialising the environment:
```
module load python
export TOIL_SLURM_ARGS="-t 0:30:00 -p staging"
. /nfs/home2/molenaar/spack/share/spack/setup-env.sh
spack load node-js
```

# running

To run the pipeline with the example dataset just run:
```bash
$ make run
```

Please examine the Makefile for other targets.
