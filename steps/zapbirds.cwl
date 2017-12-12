cwlVersion: v1.0
class: CommandLineTool
baseCommand: zapbirds

hints:
  DockerRequirement:
      dockerImageId: kernsuite/presto

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.fft)
      - entry: $(inputs.inf)

inputs:
  zapfile:
    type: File
    inputBinding:
      prefix: -zapfile

  fft:
    type: File
    inputBinding:
      position: 1

  inf:
    type: File

arguments:
  - prefix: -out
    valueFrom: $(inputs.fft.nameroot)_zapped.fft

outputs:
  zapped:
    type: File
    outputBinding:
      glob: $(inputs.fft.nameroot)_zapped.fft
