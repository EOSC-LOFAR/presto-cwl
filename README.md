# presto-cwl
CWL pipeline for presto

This is a CWL version of the workflow described in the PRESTO tutotial:

http://www.cv.nrao.edu/~sransom/PRESTO_search_tutorial.pdf

Note that this project is still very much in alpha stage and very much in flux.

# requirements

* A [CWL](http://www.commonwl.org/) runner (like [CWLtool](https://github.com/common-workflow-language/cwltool))
* [Docker](https://www.docker.com/) or [Singularity](https://www.sylabs.io/docs/) if you want to use containers


# running

To run the pipeline with the example dataset just run:
```bash
$ make run
```

Please examine the Makefile for other targets. There are many examples in there showing how to use
the pipeline using Toil, singularity, Docker and uDocker.

