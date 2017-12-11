cwlVersion: v1.0
class: CommandLineTool
baseCommand: [prepdata]

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.mask)
      - entry: $(inputs.stats)

hints:
  DockerRequirement:
      dockerImageId: kernsuite/presto

inputs:
  infile:
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
    valueFrom: $(inputs.infile.nameroot)

outputs:
  dat:
    type: File
    outputBinding:
      glob: $(inputs.infile.nameroot).dat

  inf:
    type: File
    outputBinding:
      glob: $(inputs.infile.nameroot).inf


