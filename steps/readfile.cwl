cwlVersion: v1.0
class: CommandLineTool
baseCommand: [readfile]
doc: Reads raw data from a binary file and displays it on stdout. 

hints:
  DockerRequirement:
      dockerPull: kernsuite/presto

inputs:
  filterbank:
    type: File
    inputBinding:
      position: 1

outputs:
  meta:
    type: stdout

stdout: meta

