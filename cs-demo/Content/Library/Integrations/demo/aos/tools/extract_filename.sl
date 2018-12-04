########################################################################################################################
#!!
#! @description: Generated Python operation description.
#!
#! @input input_1: Generated description
#! @input input_2: Generated description
#!
#! @output output_1: Generated description
#!
#! @result SUCCESS: Operation completed successfully.
#! @result FAILURE: Failure occurred during execution.
#!!#
########################################################################################################################

namespace: io.cloudslang.demo.aos.tools

operation:
  name: extract_filename

  inputs:
    - url

  python_action:
    script: |
      filename = url[url.rfind("/")+1:]

  outputs:
    - filename: ${filename}
    
  results:
    - SUCCESS