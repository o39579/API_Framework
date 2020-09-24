@coke-uat-api-1.0.0
@regression-1.0

Feature: Test Authorised Material List API

Background:
     * def testdata = read('../ExcelIO/readData.js')
     * def testcaseList = read(config.testsetpath+'Authorised Material List.csv')
     * def testcase = get testcaseList[?(@.YN == 'Y')]

  Scenario Outline: <Test Case Description>
    * json data = testdata('<Test Case Description>')
    * json expected_res = data.testdata.response
    * def expected_status = parseInt(data.testdata.status)
    * def method_name = data.testdata.method
    Given url data.testdata.URL
    And path data.testdata.path,''
    And header Content-Type = 'application/json'
    And param BottlerSpecificId = data.testdata.BottlerSpecificId
    And param client_id = data.testdata.client_id
    And param client_secret = data.testdata.client_secret
    And request data.testdata.request
    When method method_name
    Then def statuscode = responseStatus
    * match statuscode == expected_status
    * match response == expected_res

    Examples:
      | testcase |

    # Standard 405 Error check
  Scenario Outline: <Test Case Description>
      Given url 'https://aml-mycoke-ccna-api-uat.cloudhub.io/api'
      And path 'list'
      And header Content-Type = 'application/json'
      And param BottlerSpecificId = <BottlerSpecificId>
      And param client_id = '945e344711d647feac70f56865a6431b'
      And param client_secret = 'Ad0CDD05e9b64ea29636727BC9F3157E'
      And request {}
      When method <Method>
      Then status 405
      * match response ==
      """
      {
          "message": "Method not allowed"
      }
      """

    Examples:
      | Test Case Description | Method |  BottlerSpecificId |
      | TC_Authorised Material List_when GET Method is called    | GET | 4800 |
      | TC_Authorised Material List_when PUT Method is called    | PUT | 4800 |
      | TC_Authorised Material List_when DELETE Method is called | DELETE | 4800 |

    # Standard 415 Error check
    Scenario: TC_Authorised Material List_when request body is not in correct format
      Given url 'https://aml-mycoke-ccna-api-uat.cloudhub.io/api'
      And path 'list'
      And header Content-Type = 'application/text'
      And param BottlerSpecificId = '4800'
      And param client_id = '945e344711d647feac70f56865a6431b'
      And param client_secret = 'Ad0CDD05e9b64ea29636727BC9F3157E'
      And request 'test'
      When method POST
      Then status 415
      * match response ==
      """
      {
          "message": "Unsupported media type"
      }
      """

    # Standard 403 Error check
   Scenario: TC_Authorised Material List_when authentication credentials is not provided
     Given url 'https://aml-mycoke-ccna-api-uat.cloudhub.io/api'
     And path 'list'
     And header Content-Type = 'application/json'
     And param BottlerSpecificId = '4800'
     And request {}
     When method POST
     Then status 403
     * match response ==
     """
     {
         "error": "missing_client",
         "description": "client_id is missing"
     }
     """

  # Standard 403 Error check
     Scenario: TC_Authorised Material List_when BottlerSpecificId not provided
       Given url 'https://aml-mycoke-ccna-api-uat.cloudhub.io/api'
       And path 'list'
       And header Content-Type = 'application/json'
       And param client_id = '945e344711d647feac70f56865a6431b'
       And param client_secret = 'Ad0CDD05e9b64ea29636727BC9F3157E'
       And request {}
       When method POST
       Then status 403
       * match response ==
       """
       {
           "error": "invalid_client",
           "description": "Invalid Bottler"
       }
       """
