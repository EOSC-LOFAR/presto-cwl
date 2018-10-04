cwlVersion: v1.0
class: CommandLineTool
baseCommand: [prepfold, -noxwin]

hints:
  DockerRequirement:
      dockerPull: kernsuite/presto

requirements:
  InitialWorkDirRequirement:
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

