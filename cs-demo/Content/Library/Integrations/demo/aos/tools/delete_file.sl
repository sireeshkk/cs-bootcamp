namespace: Integrations.demo.aos.tools
flow:
  name: delete_file
  inputs:
    - host: 10.0.46.40
    - username: root
    - password: admin@123
    - filename: install_tomcat.sh
  workflow:
    - delete_file:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && rm -f '+filename}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      delete_file:
        x: 58
        y: 111
        navigate:
          e09d83e8-a7b8-474e-9ec2-07f682d59816:
            targetId: 2f1af402-5a61-045f-9434-cb7b08b98ed4
            port: SUCCESS
    results:
      SUCCESS:
        2f1af402-5a61-045f-9434-cb7b08b98ed4:
          x: 251
          y: 109
