cwlVersion: v1.0
class: CommandLineTool
baseCommand: prepsubband

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.mask)
      - entry: $(inputs.stats)

hints:
  DockerRequirement:
    dockerImageId: kernsuite/prseto

inputs:
  infile:
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

  stats:
    type: File?
    inputBinding:
      prefix: -mask


arguments:
  - prefix: -o
    valueFrom: $(inputs.infile.nameroot)


outputs:
  test:
    type: File
    outputBinding:
      glob: "*"
