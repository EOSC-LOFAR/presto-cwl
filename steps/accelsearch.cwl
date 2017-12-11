cwlVersion: v1.0
class: CommandLineTool
baseCommand: accelsearch

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.dat)
      - entry: $(inputs.inf)

hints:
  DockerRequirement:
    dockerImageId: kernsuite/prseto

inputs:
  dat:
    type: File
    inputBinding:
      position: 1

  inf:
    type: File

  numharm:
    type: int
    inputBinding:
      prefix: -numharm

  zmax:
    type: int
    inputBinding:
      prefix: -zmax

outputs:
  candidates_binary: 
    type: File
    outputBinding:
       glob: $(inputs.dat.nameroot)_ACCEL_0.cand

  candidates_text: 
    type: File
    outputBinding:
      glob: $(inputs.dat.nameroot)_ACCEL_0


