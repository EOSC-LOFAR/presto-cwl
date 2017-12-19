cwlVersion: v1.0
class: CommandLineTool
baseCommand: [%RUN_PREFIX%zapbirds, -zap]

hints:
  DockerRequirement:
      dockerImageId: kernsuite/presto

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
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
