*** Settings ***
Library    SeleniumLibrary    # For browser automation
Library    String             # For string operations
Library    EnvLibrary.py      # Custom library to fetch environment variables
Suite Setup    Initialize Environment Variables  # Load environment variables before tests

*** Variables ***
${BROWSER}                 chrome   # Browser to use for the test
${URL}                     None     # Will be set from environment variables
${USERNAME}                None     # Will be set from environment variables
${PASSWORD}                None     # Will be set from environment variables
${HEALTH_FACILITIES_URL}    None     # Will be set from environment variables
@{INSURANCE_NUMBERS}        070707066    070707070  # Insurance numbers to use
${CARE_TYPE}               IPD      # Can be 'IPD' or 'OPD'
${RANDOM_NUMBER_LENGTH}     10      # Length of the generated claim number
${LOOP_COUNT}               1       # Number of iterations for the test case loop

*** Keywords ***
Initialize Environment Variables
    [Documentation]  Load environment variables from the .env file and set them as suite variables.
    ${url}=                   Get Env Variable    URL
    ${username}=              Get Env Variable    USERNAME
    ${password}=              Get Env Variable    PASSWORD
    ${health_facilities_url}= Get Env Variable    HEALTH_FACILITY_URL
    Set Suite Variable    ${url}
    Set Suite Variable    ${username}
    Set Suite Variable    ${password}
    Set Suite Variable    ${health_facilities_url}

Open Application
    [Documentation]  Open the application in the browser and maximize the window.
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window

Login To Application
    [Documentation]  Log into the application using provided credentials.
    Wait Until Element Is Visible    css=.MuiFormControl-root .MuiInputBase-input    20s
    Input Text    css=.MuiFormControl-root .MuiInputBase-input    ${USERNAME}
    Input Text    css=.MuiFormControl-root .MuiInputBase-input[type='password']    ${PASSWORD}
    Wait Until Element Is Visible    css=.MuiButton-containedPrimary:not(.Mui-disabled)    20s
    Click Button    css=.MuiButton-containedPrimary
    Wait Until Page Contains    Welcome Admin Admin!    20s

Navigate To Health Facilities
    [Documentation]  Navigate to the Health Facilities page.
    Go To    ${HEALTH_FACILITIES_URL}

Select Claim Administrator
    [Documentation]  Search and select a claim administrator by inputting the code '35'.
    Wait Until Element Is Visible    xpath=//input[@placeholder='Search a Claim Administrator']    20s
    Input Text    xpath=//input[@placeholder='Search a Claim Administrator']    35
    Sleep    3s
    Click Element    xpath=//li[contains(text(), '35 35 35')]
    Sleep    2s

Click Floating Action Button
    [Documentation]  Click on the floating action button to start creating a new claim.
    Wait Until Element Is Visible    xpath=//button[@type='button' and contains(@class, 'MuiFab-primary')]    20s
    Click Element    xpath=//button[@type='button' and contains(@class, 'MuiFab-primary')]

Input Random Insurance Number From List
    [Documentation]  Select a random insurance number from the list and input it.
    ${random_insurance_number}=    Evaluate    random.choice(${INSURANCE_NUMBERS})    random
    Input Text    xpath=//input[@type='text' and @maxlength='12']    ${random_insurance_number}
    Log To Console  Selected Insurance No.: ${random_insurance_number}

Select Care Type (IPD/OPD)
    [Documentation]  Select the care type (either IPD or OPD).
    Click Element    xpath=//div[@id='mui-component-select-careType']
    ${care_value}=    Set Variable    ${CARE_TYPE}
    Click Element    xpath=//li[text()='${care_value}']

Select Diagnosis
    [Documentation]  Search and select the diagnosis code 'A000'.
    Wait Until Element Is Visible    xpath=//input[@placeholder='Search Diagnosis…']    20s
    Input Text    xpath=//input[@placeholder='Search Diagnosis…']    A000
    Sleep    2s
    Click Element    xpath=//li[contains(text(), 'A000')]

Input Claim Number
    [Documentation]  Generate a random claim number and input it.
    ${claim_number}=    Evaluate    ''.join(str(random.randint(0, 9)) for _ in range(${RANDOM_NUMBER_LENGTH}))    random
    Input Text    xpath=//input[@maxlength='8']    ${claim_number}
    Log To Console  Generated Claim No.: ${claim_number}

Select Service And Quantity
    [Documentation]  Search and select a service, and input the quantity as 1.
    Wait Until Element Is Visible    xpath=//input[@placeholder='Search Service…']    20s
    Input Text    xpath=//input[@placeholder='Search Service…']    ""
    Sleep    3s
    Click Element    xpath=//li[contains(text(), 'M1 OBG Cervical Cerclage - Shrodikar')]
    Wait Until Element Is Visible    xpath=//tr[@class='MuiTableRow-root jss348']//input[@type='number' and @max='10000']    5s
    Click Element    xpath=//tr[@class='MuiTableRow-root jss348']//input[@type='number' and @max='10000']
    Press Keys    xpath=//tr[@class='MuiTableRow-root jss348']//input[@type='number' and @max='10000']    BACKSPACE
    Press Keys    xpath=//tr[@class='MuiTableRow-root jss348']//input[@type='number' and @max='10000']    1
    Log To Console    Selected Service and Quantity: M1 OBG Cervical Cerclage - Shrodikar, Quantity: 1

Input Text Into Explanation
    [Documentation]  Input explanation text for the claim.
    Wait Until Element Is Visible    xpath=(//td[@class='MuiTableCell-root MuiTableCell-body'])[4]//input[@type='text']    20s
    Click Element    xpath=(//td[@class='MuiTableCell-root MuiTableCell-body'])[4]//input[@type='text']
    Press Keys    xpath=(//td[@class='MuiTableCell-root MuiTableCell-body'])[4]//input[@type='text']    BACKSPACE
    Press Keys    xpath=(//td[@class='MuiTableCell-root MuiTableCell-body'])[4]//input[@type='text']    Robot framework text input automation
    Log To Console    Input text: Robot framework text input automation

Click Save Button
    [Documentation]  Save the claim.
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'MuiFab-primary')]    20s
    Click Element    xpath=//button[contains(@class, 'MuiFab-primary')]

Input Insuree No in Filter Claim
    [Documentation]  Filter claims using an insuree number.
    Wait Until Element Is Visible    xpath=//div[@class='MuiGrid-root jss1198 MuiGrid-item MuiGrid-grid-xs-3']//input[@name='chfId']    20s
    Click Element    xpath=//div[@class='MuiGrid-root jss1198 MuiGrid-item MuiGrid-grid-xs-3']//input[@name='chfId']
    Input Text    xpath=//div[@class='MuiGrid-root jss1198 MuiGrid-item MuiGrid-grid-xs-3']//input[@name='chfId']    070707070
    Sleep    5s
    Log To Console    Inputted Insuree No.: 070707070

Click Top 4 Table Rows
    [Documentation]  Click the top 4 rows in the table.
    Wait Until Element Is Visible    xpath=//table//tbody//tr    20s
    Click Element    xpath=(//table//tbody//tr)[1]
    Sleep    1s
    Click Element    xpath=(//table//tbody//tr)[2]
    Sleep    1s
    Click Element    xpath=(//table//tbody//tr)[3]
    Sleep    1s
    Click Element    xpath=(//table//tbody//tr)[4]
    Sleep    1s
    Log To Console    Clicked on the top 4 table rows

Close Application
    [Documentation]  Close the browser after completing the test.
    Close Browser

*** Test Cases ***
Login and Complete Insurance Form
    [Documentation]  Perform end-to-end testing of the insurance form workflow.
    Open Application
    Login To Application
    ${iterations}=    Evaluate    ${LOOP_COUNT} + 1
    FOR    ${i}    IN RANGE    1    ${iterations}
        Navigate To Health Facilities
        Select Claim Administrator
        Click Floating Action Button
        Input Random Insurance Number From List
        Select Care Type (IPD/OPD)
        Select Diagnosis
        Input Claim Number
        Select Service And Quantity
        Sleep    2s
        Input Text Into Explanation
        Sleep    2s
        Click Save Button
        Sleep    10s
    END
    Navigate
