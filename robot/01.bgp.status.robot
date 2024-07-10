*** Settings ***
Library    SSHLibrary

*** Variables ***
@{HOSTS}  
    ...    10.0.137.7     #T7
    ...    10.0.137.8     #T8
    ...    10.0.137.9     #T9
    ...    10.0.137.10    #T10
    ...    10.0.137.19    #RS19
    ...    10.0.137.20    #T20
    ...    10.0.137.21    #T21
    ...    10.0.137.22    #RR22
    ...    10.0.137.23    #RR23
${USERNAME}    admin
${PASSWORD}    admin
${DEVICE_TYPE}    arista_eos
${JUMPSERVER}    192.168.86.3

*** Keywords ***
Open Connection and Log In
    [Arguments]    ${HOST}
    Open Connection    ${HOST}
    Login              ${USERNAME}    ${PASSWORD}    proxy_cmd=ssh -l root -i ~/.ssh/id_rsa -W ${HOST}:22 ${JUMPSERVER}

Verify Bgp Sessions
    ${SHOW_BGP_NEIGHBORS}=    Execute Command    show bgp neighbors
    ${COUNT_BGP_NEIGHBORS}=    Get Count    ${SHOW_BGP_NEIGHBORS}    BGP neighbor is
    ${COUNT_BGP_ESTABLISHED}=   Get Count    ${SHOW_BGP_NEIGHBORS}    TCP state is ESTABLISHED
    Should Be Equal    ${COUNT_BGP_NEIGHBORS}    ${COUNT_BGP_ESTABLISHED}

*** Test Cases ***
Validate Routing Protocols Status
    FOR    ${HOST}    IN    @{HOSTS}
        Log    Executing tests for host: ${HOST}
        Run Keyword And Continue On Failure    Open Connection and Log In    ${HOST}
        Run Keyword And Continue On Failure    Verify Bgp Sessions
        Close All Connections
    END
