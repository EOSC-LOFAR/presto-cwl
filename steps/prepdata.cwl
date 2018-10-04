cwlVersion: v1.0
class: CommandLineTool
baseCommand: [prepdata]

requirements:
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.mask)
      - entry: $(inputs.stats)

hints:
  DockerRequirement:
      dockerPull: kernsuite/presto

inputs:
  filterbank:
    type: File
    inputBinding:
      position: 1

  nobary:
    type: boolean?
    inputBinding:
      prefix: -nobary

  mask:
    type: File
    inputBinding:
      prefix: -mask

  stats:
    type: File

  dm:
    type: float?
    doc: The dispersion measure to de-disperse (cm^-3 pc)
    inputBinding:
      prefix: -dm

  numout:
    type: int?
    inputBinding:
       prefix: -numout
 

arguments:
  - prefix: -o
    valueFrom: $(inputs.filterbank.nameroot)

outputs:
  dat:
    type: File
    outputBinding:
      glob: $(inputs.filterbank.nameroot).dat

  inf:
    type: File
    outputBinding:
      glob: $(inputs.filterbank.nameroot).inf


