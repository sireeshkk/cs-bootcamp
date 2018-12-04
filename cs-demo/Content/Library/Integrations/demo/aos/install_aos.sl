namespace: Integrations.demo.aos
flow:
  name: install_aos
  inputs:
    - username: "${get_sp('vm_username')}"
    - password: "${get_sp('vm_password')}"
    - tomcat_host: 10.0.46.40
    - account_service_host:
        default: 10.0.46.40
        required: false
    - db_host:
        default: 10.0.46.40
        required: false
  workflow:
    - install_postgres:
        do:
          Integrations.demo.aos.sub_flows.initialize_artifact:
            - host: "${get('db_host', tomcat_host)}"
            - username: "${get_sp('vm_username')}"
            - password: "${get_sp('vm_password')}"
            - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_postgres.sh'
        publish: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: installl_java
    - installl_java:
        do:
          Integrations.demo.aos.sub_flows.initialize_artifact:
            - host: '${tomcat_host}'
            - username: "${get_sp('vm_username')}"
            - password: "${get_sp('vm_password')}"
            - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_java.sh'
        publish: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_tomcat
    - install_tomcat:
        do:
          Integrations.demo.aos.sub_flows.initialize_artifact:
            - host: '${tomcat_host}'
            - username: "${get_sp('vm_username')}"
            - password: "${get_sp('vm_password')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_true
    - is_true:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(get('account_service_host', tomcat_host) != tomcat_host)}"
        navigate:
          - 'TRUE': install_java_as
          - 'FALSE': deploy_wars
    - install_java_as:
        do:
          Integrations.demo.aos.sub_flows.initialize_artifact:
            - host: '${account_service_host}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_tomcat_as
    - deploy_wars:
        do:
          Integrations.demo.aos.sub_flows.deploy_wars:
            - tomcat_host: '${tomcat_host}'
            - account_service_host: "${get('db_host', tomcat_host)}"
            - db_host: "${get('db_host', tomcat_host)}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - install_tomcat_as:
        do:
          Integrations.demo.aos.sub_flows.initialize_artifact:
            - host: '${account_service_host}'
            - username: "${get_sp('vm_username')}"
            - password: "${get_sp('vm_password')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: deploy_wars
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      install_postgres:
        x: 44
        y: 104
      installl_java:
        x: 216
        y: 100
      install_tomcat:
        x: 382
        y: 102
      is_true:
        x: 625
        y: 85
      install_java_as:
        x: 588
        y: 300
      deploy_wars:
        x: 785
        y: 101
        navigate:
          96869115-c9db-ca55-22a1-f6d1faeb709d:
            targetId: 9faa6631-9236-bc49-6bcb-936a127c26ec
            port: SUCCESS
      install_tomcat_as:
        x: 790
        y: 296
    results:
      SUCCESS:
        9faa6631-9236-bc49-6bcb-936a127c26ec:
          x: 979
          y: 97
