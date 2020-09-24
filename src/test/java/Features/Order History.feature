@coke-uat-api-1.0.0
@regression-1.0

Feature: Test Order History API

Background:
     * def testdata = read('../ExcelIO/readData.js')
     * def testcaseList = read(config.testsetpath+'Order History.csv')
     * def testcase = get testcaseList[?(@.YN == 'Y')]

  Scenario Outline: <Test Case Description>
    * json data = testdata('<Test Case Description>')
    * json expected_res = data.testdata.response
    * def expected_status = parseInt(data.testdata.status)
    * def method_name = data.testdata.method
    * def username = data.testdata.username
    * def password = data.testdata.password
    Given url data.testdata.URL
    And path data.testdata.path,''
    And header Content-Type = 'application/json'
    And header Authorization = call read('../basic-auth.js') { username: '#(username)', password: '#(password)' }
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
    Scenario: TC_Order History_when request body is not in correct format
      Given url 'https://orderhistory-mycoke-ccna-api-uat.cloudhub.io/api/v1'
      And path 'getHistoryRealTime'
      And header Content-Type = 'application/text'
      And header Authorization = call read('../basic-auth.js') { username: 'CloudhubUser4ConaAPI', password: 'GreenApple8964' }
      And param BottlerSpecificId = '5000'
      And param client_id = '032a90fedf40480582916b7300f56db2'
      And param client_secret = 'Bb2dc1cb250a4161BE352599733d2f8b'
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
   Scenario: TC_Order History_when authentication credentials is not provided
     Given url 'https://orderhistory-mycoke-ccna-api-uat.cloudhub.io/api/v1'
     And path 'getHistoryRealTime'
     And header Content-Type = 'application/json'
     And header Authorization = call read('../basic-auth.js') { username: 'CloudhubUser4ConaAPI', password: 'GreenApple8964' }
     And param BottlerSpecificId = '5000'
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
     Scenario: TC_Order History_when BottlerSpecificId not provided
       Given url 'https://orderhistory-mycoke-ccna-api-uat.cloudhub.io/api/v1'
       And path 'getHistoryRealTime'
       And header Content-Type = 'application/json'
       And header Authorization = call read('../basic-auth.js') { username: 'CloudhubUser4ConaAPI', password: 'GreenApple8964' }
       And param client_id = '032a90fedf40480582916b7300f56db2'
       And param client_secret = 'Bb2dc1cb250a4161BE352599733d2f8b'
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

    # Standard 401 Error check
     Scenario: TC_Order History_when Basic Authentication is not provided
       Given url 'https://orderhistory-mycoke-ccna-api-uat.cloudhub.io/api/v1'
       And path 'getHistoryRealTime'
       And header Content-Type = 'application/json'
       And param BottlerSpecificId = '5000'
       And param client_id = '032a90fedf40480582916b7300f56db2'
       And param client_secret = 'Bb2dc1cb250a4161BE352599733d2f8b'
       And request {}
       When method POST
       Then status 401
       And match response contains 'Authentication denied'


  # Standard 401 Error check
      Scenario: TC_Order History_when Basic Authentication is incorrect
        Given url 'https://orderhistory-mycoke-ccna-api-uat.cloudhub.io/api/v1'
        And path 'getHistoryRealTime'
        And header Content-Type = 'application/json'
        And header Authorization = call read('../basic-auth.js') { username: 'CloudhubUser', password: 'GreenApple' }
        And param BottlerSpecificId = '5000'
        And param client_id = '032a90fedf40480582916b7300f56db2'
        And param client_secret = 'Bb2dc1cb250a4161BE352599733d2f8b'
        And request {}
        When method POST
        Then status 401
        And match response contains 'Authentication failed'
