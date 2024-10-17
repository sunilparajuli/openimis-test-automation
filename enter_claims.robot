*** Settings ***
Library           SeleniumLibrary
Library           String

*** Variables ***
${URL}            https://release.openimis.org/front/login
${BROWSER}        chrome
${USERNAME}       Admin
${PASSWORD}       admin123
${HEALTH_FACILITIES_URL}    https://release.openimis.org/front/claim/healthFacilities

# List of Insurance Numbers
@{INSURANCE_NUMBERS}    070707066    070707070
${CARE_TYPE}      IPD   # You can set this to OPD if needed
${RANDOM_NUMBER_LENGTH}     10  # You can set this to a different value if needed
${LOOP_COUNT}    4  # Set your desired loop count here
*** Keywords ***
Open Application
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window

Login To Application
    Wait Until Element Is Visible    css=.MuiFormControl-root .MuiInputBase-input    20s
    Input Text    css=.MuiFormControl-root .MuiInputBase-input    ${USERNAME}  # Username input
    Input Text    css=.MuiFormControl-root .MuiInputBase-input[type='password']    ${PASSWORD}  # Password input
    Wait Until Element Is Visible    css=.MuiButton-containedPrimary:not(.Mui-disabled)    20s
    Click Button    css=.MuiButton-containedPrimary    # Login button
    Wait Until Page Contains    Welcome Admin Admin!    20s

Navigate To Health Facilities
    Go To    ${HEALTH_FACILITIES_URL}

Select Claim Administrator
    Wait Until Element Is Visible    xpath=//input[@placeholder='Search a Claim Administrator']    20s
    Input Text    xpath=//input[@placeholder='Search a Claim Administrator']    35
    Sleep    3s  # Wait for the dropdown options to appear
    Click Element    xpath=//li[contains(text(), '35 35 35')]
    Sleep    2s

Click Floating Action Button
    Wait Until Element Is Visible    xpath=//button[@type='button' and contains(@class, 'MuiFab-primary')]    20s
    Click Element    xpath=//button[@type='button' and contains(@class, 'MuiFab-primary')]

Input Random Insurance Number From List
    # Pick a random insurance number from the list
    ${random_insurance_number}=    Evaluate    random.choice(${INSURANCE_NUMBERS})    random
    Input Text      xpath=//input[@type='text' and @maxlength='12']    ${random_insurance_number}
    Log To Console  Selected Insurance No.: ${random_insurance_number}


Select Care Type (IPD/OPD)
    # Open the dropdown for care type
    Click Element    xpath=//div[@id='mui-component-select-careType']
    
    # Select the care type (IPD or OPD)
    ${care_value}=    Set Variable    ${CARE_TYPE}
    Click Element    xpath=//li[text()='${care_value}']


Select Diagnosis
    # Type the diagnosis code (A000) into the input field
    Wait Until Element Is Visible    xpath=//input[@placeholder='Search Diagnosis…']    20s
    Input Text    xpath=//input[@placeholder='Search Diagnosis…']    A000
    
    # Wait for 2 seconds to allow the dropdown options to appear
    Sleep    2s

    # Select the diagnosis from the dropdown (assuming the value starts with 'A000')
    Click Element    xpath=//li[contains(text(), 'A000')]


Input Claim Number
    # Generate a random number with the specified length
    ${claim_number}=    Evaluate    ''.join(str(random.randint(0, 9)) for _ in range(${RANDOM_NUMBER_LENGTH}))    random
    Input Text    xpath=//input[@maxlength='8']    ${claim_number}
    Log To Console  Generated Claim No.: ${claim_number}


Select Service And Quantity
    Wait Until Element Is Visible    xpath=//input[@placeholder='Search Service…']    20s
    Input Text    xpath=//input[@placeholder='Search Service…']    ""
    Sleep    3s  # Allow time for the dropdown to load
    Click Element    xpath=//li[contains(text(), 'M1 OBG Cervical Cerclage - Shrodikar')]

    # Input quantity with backspace
    Wait Until Element Is Visible    xpath=//tr[@class='MuiTableRow-root jss348']//input[@type='number' and @max='10000']    5s
    Click Element    xpath=//tr[@class='MuiTableRow-root jss348']//input[@type='number' and @max='10000']
    Press Keys    xpath=//tr[@class='MuiTableRow-root jss348']//input[@type='number' and @max='10000']    BACKSPACE
    Press Keys    xpath=//tr[@class='MuiTableRow-root jss348']//input[@type='number' and @max='10000']    1
    Log To Console    Selected Service and Quantity: M1 OBG Cervical Cerclage - Shrodikar, Quantity: 1

Input Text Into Explanation
    # Wait until the fourth input text field within the fourth <td> is visible
    Wait Until Element Is Visible    xpath=(//td[@class='MuiTableCell-root MuiTableCell-body'])[4]//input[@type='text']    20s
    
    # Click on the input element inside the fourth <td>
    Click Element    xpath=(//td[@class='MuiTableCell-root MuiTableCell-body'])[4]//input[@type='text']
    
    # Clear the input field (using BACKSPACE to ensure no previous text)
    Press Keys    xpath=(//td[@class='MuiTableCell-root MuiTableCell-body'])[4]//input[@type='text']    BACKSPACE
    
    # Enter the text into the input field
    Press Keys    xpath=(//td[@class='MuiTableCell-root MuiTableCell-body'])[4]//input[@type='text']    Robot framework text input automation
    
    # Log the inputted text
    Log To Console    Input text: Robot framework text input automation


Click Save Button
    [Documentation]   Clicks the save button after entering service and quantity.
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'MuiFab-primary')]    20s
    Click Element    xpath=//button[contains(@class, 'MuiFab-primary')]


Input Insuree No in Filter Claim
    Wait Until Element Is Visible    xpath=//div[@class='MuiGrid-root jss1198 MuiGrid-item MuiGrid-grid-xs-3']//input[@name='chfId']    20s
    Click Element    xpath=//div[@class='MuiGrid-root jss1198 MuiGrid-item MuiGrid-grid-xs-3']//input[@name='chfId']
    Input Text    xpath=//div[@class='MuiGrid-root jss1198 MuiGrid-item MuiGrid-grid-xs-3']//input[@name='chfId']    070707070  # Change the number to the desired Insuree No.
    Sleep    5s
    Log To Console    Inputted Insuree No.: 123456789


Click Top 4 Table Rows
    # Wait for the table rows to be visible
    Wait Until Element Is Visible    xpath=//table//tbody//tr    20s
    
    # Click on the top 4 rows (first four <tr> elements within <tbody>)
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
    Close Browser

*** Test Cases ***
Login and Complete Insurance Form
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
        sleep    2s
        Input Text Into Explanation
        Sleep    2s  # Optional: Allow time for operations to complete
        Click Save Button
        Sleep    10s  # Optional: Allow time for operations to complete
    END
    Navigate To Health Facilities
    Input Insuree No in Filter Claim
    Click Top 4 Table Rows
    Close Application
