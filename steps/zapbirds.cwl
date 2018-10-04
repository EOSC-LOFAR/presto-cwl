cwlVersion: v1.0
class: CommandLineTool
baseCommand: [zapbirds, -zap]

hints:
  DockerRequirement:
      dockerPull: kernsuite/presto

requirements:
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.fft)
        writable: true
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

outputs:
  zapped:
    type: File
    outputBinding:
      glob: $(inputs.fft.basename)
