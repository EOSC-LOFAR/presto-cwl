#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: ExpressionTool

requirements:
  InlineJavascriptRequirement: {}

inputs:
  array_of_files: File[]

outputs:
  sorted_array_of_files: File[]

expression: |
  ${ return { "sorted_array_of_files": inputs.array_of_files.sort(
       (a, b) => a.basename.localeCompare(b.basename)) };
   }
