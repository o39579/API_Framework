@regression-1.0
@coke-uat-api-1.0.0

Feature: Test Delivery Date API

Background:
     * def testdata = read('../ExcelIO/readData.js')
     * def testcaseList = read(config.testsetpath+'Delivery Date.csv')
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
    * def schema = {"deliveryDate": "#string","orderByDate": "#string","orderByTime": "#string"}
    * match response == expected_res

    Examples:
      | testcase |

# Standard 415 Error check
    Scenario: TC_Delivery Date_when request body is not in correct format
      Given url 'https://deliverydate-mycoke-ccna-api-uat.cloudhub.io/api/v1'
      And path 'deliverydate'
      And header Content-Type = 'application/text'
      And param BottlerSpecificId = '4400'
      And param client_id = 'add1849727e34ae989e3fbe0894083ad'
      And param client_secret = '0CACb87F6a7b43628b06d407dd101262'
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
   Scenario: TC_Delivery Date_when authentication credentials is not provided
     Given url 'https://deliverydate-mycoke-ccna-api-uat.cloudhub.io/api/v1'
     And path 'deliverydate'
     And header Content-Type = 'application/json'
     And param BottlerSpecificId = '4400'
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
     Scenario: TC_DeliveryDate_when BottlerSpecificId not provided
       Given url 'https://deliverydate-mycoke-ccna-api-uat.cloudhub.io/api/v1'
       And path 'deliverydate'
       And header Content-Type = 'application/json'
       And param client_id = 'add1849727e34ae989e3fbe0894083ad'
       And param client_secret = '0CACb87F6a7b43628b06d407dd101262'
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
