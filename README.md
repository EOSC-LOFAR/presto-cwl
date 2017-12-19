# presto-cwl
CWL pipeline for presto

This is a CWL version of the workflow described in the PRESTO tutotial:

http://www.cv.nrao.edu/~sransom/PRESTO_search_tutorial.pdf

# requirements

* [Docker](https://www.docker.com/)
* A [CWL](http://www.commonwl.org/) runner (like [CWLtool](https://github.com/common-workflow-language/cwltool))
# usage

# preperations

for a normal run:
```
$ sed -i 's/%RUN_PREFIX%//g' steps/*.cwl
```

for running using singularity for example:
```
sed -i 's/%RUN_PREFIX%/singularity, exec, \/home\/molenaar\/presto-cwl\/presto.simg, /g' steps/*.cwl
```

# running

To run the pipeline with the example dataset just run:
```bash
$ make run
```
