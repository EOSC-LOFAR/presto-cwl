cwlVersion: v1.0
class: CommandLineTool
baseCommand: [%RUN_PREFIX%prepfold, -noxwin]

hints:
  DockerRequirement:
      dockerImageId: kernsuite/presto

requirements:
  #- class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.accel)
      - entry: $(inputs.dat)
      - entry: $(inputs.inf)

inputs:
  accel:
    type: File
    inputBinding:
      prefix: -accelfile

  dat:
    type: File
    inputBinding:
      position: 1

  inf:
    type: File

  accelcand:
    type: int
    inputBinding:
      prefix: -accelcand

outputs:
  pfd:
    type: File
    outputBinding:
      glob: "*.pfd"

  bestprof:
    type: File
    outputBinding:
      glob: "*.bestprof"

