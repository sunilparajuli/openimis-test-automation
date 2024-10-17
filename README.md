# Robot Framework OpenIMIS Automation

This project contains automated test cases for the OpenIMIS platform using **Robot Framework** and **SeleniumLibrary**. It covers workflows such as login, navigating health facilities, creating claims, and inputting insurance and service data. 

## What is Robot Framework?

**Robot Framework** is a Python-based, open-source test automation framework for acceptance testing and robotic process automation (RPA). It uses easy-to-read, plain text syntax to write test cases, making it suitable for both technical and non-technical users. The framework supports libraries such as **SeleniumLibrary** for browser automation, enabling automation of web-based applications.

## Features of This Project
- Login automation on the OpenIMIS platform.
- Navigation through Health Facilities.
- Inputting insurance numbers and claim details.
- Service and diagnosis selection with validation.
- Ability to loop multiple test iterations dynamically.

---

## How to Write Tests in Robot Framework

A test case in Robot Framework is written using a simple table-based syntax. Below is an example of a test case in openIMIS:

```robot
*** Test Cases ***
Login and Verify Home Page
    Open Browser    https://openimis.org/release    chrome
    Input Text      id=username    testuser
    Input Text      id=password    testpassword
    Click Button    id=loginButton
    Page Should Contain    Welcome, Admin!




Installation Instructions
Follow these steps to set up the environment and run the tests.

Prerequisites
Python 3.x installed on your machine.
Google Chrome browser installed (or update the tests for another browser).
ChromeDriver installed and added to your system PATH.
You can download it from ChromeDriver Downloads. Make sure the version matches your browser.


Step 1: Clone the Repository

git clone <your-repo-url>
cd <your-repo-folder>


Step 2: Create a Virtual Environment (Optional but Recommended)

python -m venv venv


Activate the virtual environment:

On Linux/Mac:

bash
source venv/bin/activate
On Windows:

bash
venv\Scripts\activate


Step 4: Set Up Environment Variables
Create a new .env file by copying the provided .env.example:

cp .env.example .env


Step 5: Run the Tests

robot filename {claim_entry.robot}.robot


Step 6: View Test Results
After running the tests, Robot Framework generates the following files:

log.html: Detailed execution log.
report.html: Summary report.
output.xml: Execution details in XML format.
You can open log.html or report.html in any browser to view the results.


Troubleshooting
Browser not launching?
Ensure that the correct version of ChromeDriver is installed and available in your system PATH.

Environment variables not loading?
Make sure you have created a .env file with correct values.

