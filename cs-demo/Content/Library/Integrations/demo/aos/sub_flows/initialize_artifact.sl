namespace: Integrations.demo.aos.sub_flows
flow:
  name: initialize_artifact
  inputs:
    - host: 10.0.46.40
    - username: root
    - password: admin@123
    - artifact_url:
        required: false
    - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_tomcat.sh'
    - parameters:
        required: false
  workflow:
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${artifact_url}'
            - second_string: ''
        navigate:
          - SUCCESS: copy_script
          - FAILURE: copy_artifact
    - copy_artifact:
        do:
          Integrations.demo.aos.sub_flows.remote_copy:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - url: '${artifact_url}'
        publish:
          - artifact_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: copy_script
    - copy_script:
        do:
          Integrations.demo.aos.sub_flows.remote_copy:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - url: '${script_url}'
        publish:
          - script_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: execute_script
    - execute_script:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && chmod 755 '+script_name+' && sh '+script_name+' '+get('artifact_name', '')+' '+get('parameters', '')+' > '+script_name+'.log'}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - command_return_code
        navigate:
          - SUCCESS: delete_script
          - FAILURE: delete_script
    - delete_script:
        do:
          Integrations.demo.aos.tools.delete_file: []
        navigate:
          - SUCCESS: is_true
          - FAILURE: on_failure
    - is_true:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(command_return_code == '0')}"
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      string_equals:
        x: 284
        y: 33
      copy_artifact:
        x: 115
        y: 192
      copy_script:
        x: 398
        y: 201
      execute_script:
        x: 64
        y: 338
      delete_script:
        x: 277
        y: 336
      is_true:
        x: 528
        y: 323
        navigate:
          2a7adbf6-ed57-1a8d-2cea-7394bc13c44f:
            targetId: f8b664fb-fba6-eeaf-ce62-6ec1fe4fd727
            port: 'TRUE'
          bc79d348-4992-6c3f-a71c-f0d36fefeca7:
            targetId: df62c85f-4eb0-b80b-e3c7-4e7f83be4e47
            port: 'FALSE'
    results:
      FAILURE:
        df62c85f-4eb0-b80b-e3c7-4e7f83be4e47:
          x: 647
          y: 427
      SUCCESS:
        f8b664fb-fba6-eeaf-ce62-6ec1fe4fd727:
          x: 632
          y: 205
