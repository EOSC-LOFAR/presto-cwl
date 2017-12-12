cwlVersion: v1.0
class: CommandLineTool
baseCommand: realfft

hints:
  DockerRequirement:
      dockerImageId: kernsuite/presto

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.dat)

inputs:
  dat:
    type: File
    inputBinding:
      position: 1

  fwd:
    type: boolean?
    doc: Force an forward FFT (sign=-1) to be performed
    inputBinding:
      prefix: -fwd

  inv:
    type: boolean?
    doc: Force an inverse FFT (sign=+1) to be performed
    inputBinding:
      prefix: -inv

  disk: 
    type: boolean?
    doc: Force the use of the out-of-core memory FFT
    inputBinding:
      prefix: -disk

  mem:
    type: boolean?
    doc: Force the use of the in-core memory FFT
    inputBinding:
      prefix: -mem

outputs:
  fft:
    type: File
    outputBinding:
      glob: $(inputs.dat.nameroot).fft
