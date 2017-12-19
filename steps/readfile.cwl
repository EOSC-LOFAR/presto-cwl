cwlVersion: v1.0
class: CommandLineTool
baseCommand: [singularity, exec, /home/molenaar/presto-cwl/presto.simg, readfile]
doc: Reads raw data from a binary file and displays it on stdout. 

hints:
  DockerRequirement:
      dockerImageId: kernsuite/presto

inputs:
  filterbank:
    type: File
    inputBinding:
      position: 1

outputs:
  meta:
    type: stdout

stdout: meta

