cwlVersion: v1.0
class: CommandLineTool
baseCommand: [makezaplist.py]

hints:
  DockerRequirement:
      dockerImageId: kernsuite/presto

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.inf)
        entryname: $(inputs.birds.nameroot).inf
      - entry: $(inputs.birds)

inputs:
  inf:
    type: File

  birds:
    type: File
    inputBinding:
      position: 1

outputs:
  zaplist:
    type: File
    outputBinding:
      glob: $(inputs.birds.nameroot).zaplist
