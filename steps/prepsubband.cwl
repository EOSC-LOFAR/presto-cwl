cwlVersion: v1.0
class: CommandLineTool
baseCommand: [prepsubband]

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.mask)
      - entry: $(inputs.stats)

hints:
  DockerRequirement:
    dockerImageId: kernsuite/presto

inputs:
  filterbank:
    type: File
    inputBinding:
      position: 1

  nsub:
    type: int?
    inputBinding:
      prefix: -nsub

  lodm:
    type: float?
    inputBinding:
      prefix: -lodm

  dmstep:
    type: float?
    inputBinding:
      prefix: -dmstep

  numdms:
    type: int?
    inputBinding:
      prefix: -numdms

  numout:
    type: int?
    inputBinding:
      prefix: -numout

  downsamp:
    type: int?
    inputBinding:
      prefix: -downsamp

  mask:
    type: File?
    inputBinding:
      prefix: -mask

  nobary:
    type: boolean
    inputBinding:
      prefix: -nobary

  stats:
    type: File?

arguments:
  - prefix: -o
    valueFrom: $(inputs.filterbank.nameroot)


outputs:
  dats:
    type: File[]
    outputBinding:
      glob: "$(inputs.filterbank.nameroot)_*.00.dat"

  infs:
    type: File[]
    outputBinding:
      glob: "$(inputs.filterbank.nameroot)_*.00.inf"
