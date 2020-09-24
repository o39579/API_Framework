@coke-uat-api-1.0.0
@regression-1.0

Feature: Test Order Create,Cancel,Track and simulate API

Background:
     * def testdata = read('../ExcelIO/readData.js')
     * def testcaseList = read(config.testsetpath+'Order.csv')
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
    * match response contains expected_res

    Examples:
      | testcase |

    # Standard 415 Error check
    Scenario Outline: <Test Description>
      Given url <url>
      And path <path>
      And header Content-Type = 'application/text'
      And header Authorization = call read('../basic-auth.js') { username: 'CloudhubUser4ConaAPI', password: 'GreenApple8964' }
      And param BottlerSpecificId = <BottlerSpecificId>
      And param client_id = <client_id>
      And param client_secret = <client_secret>
      And request 'test'
      When method POST
      Then status 415
      * match response ==
      """
      {
          "message": "Unsupported media type"
      }
      """
    Examples:
    | Test Description | url | path |  BottlerSpecificId | client_id | client_secret |
    | 'TC_Order Create_when request body is not in correct format' | 'https://order-mycoke-ccna-api-uat.cloudhub.io/api/v1' | 'create' | '4500' | '945e344711d647feac70f56865a6431b' | 'Ad0CDD05e9b64ea29636727BC9F3157E' |
    | 'TC_Order Cancel_when request body is not in correct format' | 'https://order-mycoke-ccna-api-uat.cloudhub.io/api/v1' | 'cancel' | '4500' | '945e344711d647feac70f56865a6431b' | 'Ad0CDD05e9b64ea29636727BC9F3157E' |
    | 'TC_Order Track_when request body is not in correct format' | 'https://trackorder-cona-to-mycoke-interface-uat.us-w2.cloudhub.io/api' | 'trackorder' | '5000' | '62902dba0c504eeb81d4a237cdcc5105' | 'F689deb575a54074Ab0C64aA7837702f' |
    | 'TC_Order simulate_when request body is not in correct format' | 'https://order-mycoke-ccna-api-uat.cloudhub.io/api/v1' | 'simulate' | '4500' | '945e344711d647feac70f56865a6431b' | 'Ad0CDD05e9b64ea29636727BC9F3157E' |

    # Standard 403 Error check
   Scenario Outline: <Test Description>
     Given url <url>
     And path <path>
     And header Content-Type = 'application/json'
     And header Authorization = call read('../basic-auth.js') { username: 'CloudhubUser4ConaAPI', password: 'GreenApple8964' }
     And param BottlerSpecificId = <BottlerSpecificId>
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
    Examples:
        | Test Description | url | path |  BottlerSpecificId |
        | 'TC_Order create_when authentication credentials is not provided' | 'https://order-mycoke-ccna-api-uat.cloudhub.io/api/v1' | 'create' | '4500' |
        | 'TC_Order cancel_when authentication credentials is not provided' | 'https://order-mycoke-ccna-api-uat.cloudhub.io/api/v1' | 'cancel' | '4500' |
        | 'TC_Order Track_when authentication credentials is not provided' | 'https://trackorder-cona-to-mycoke-interface-uat.us-w2.cloudhub.io/api' | 'trackorder' | '5000' |
        | 'TC_Order simulate_when authentication credentials is not provided' | 'https://order-mycoke-ccna-api-uat.cloudhub.io/api/v1' | 'simulate' | '4500' |

  # Standard 403 Error check
     Scenario Outline: <Test Description>
       Given url <url>
       And path <path>
       And header Content-Type = 'application/text'
       And header Authorization = call read('../basic-auth.js') { username: 'CloudhubUser4ConaAPI', password: 'GreenApple8964' }
       And param client_id = <client_id>
       And param client_secret = <client_secret>
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
    Examples:
        | Test Description | url | path |  BottlerSpecificId | client_id | client_secret |
        | 'TC_Order Create_when BottlerSpecificId not provided' | 'https://order-mycoke-ccna-api-uat.cloudhub.io/api/v1' | 'create' | '4500' | '945e344711d647feac70f56865a6431b' | 'Ad0CDD05e9b64ea29636727BC9F3157E' |
        | 'TC_Order cancel_when BottlerSpecificId not provided' | 'https://order-mycoke-ccna-api-uat.cloudhub.io/api/v1' | 'cancel' | '4500' | '945e344711d647feac70f56865a6431b' | 'Ad0CDD05e9b64ea29636727BC9F3157E' |
        | 'TC_Order Simulate_when BottlerSpecificId not provided' | 'https://order-mycoke-ccna-api-uat.cloudhub.io/api/v1' | 'simulate' | '4500' | '945e344711d647feac70f56865a6431b' | 'Ad0CDD05e9b64ea29636727BC9F3157E' |

    # Standard 401 Error check
     Scenario: TC_Order track_when Basic Authentication is not provided
       Given url 'https://trackorder-cona-to-mycoke-interface-uat.us-w2.cloudhub.io/api'
       And path 'trackorder'
       And header Content-Type = 'application/json'
       And param BottlerSpecificId = '5000'
       And param client_id = '62902dba0c504eeb81d4a237cdcc5105'
       And param client_secret = 'F689deb575a54074Ab0C64aA7837702f'
       And request {}
       When method POST
       Then status 401
       And match response contains 'Authentication denied'


  # Standard 401 Error check
      Scenario: TC_Order Track_when Basic Authentication is incorrect
        Given url 'https://trackorder-cona-to-mycoke-interface-uat.us-w2.cloudhub.io/api'
        And path 'trackorder'
        And header Content-Type = 'application/json'
        And header Authorization = call read('../basic-auth.js') { username: 'CloudhubUser', password: 'GreenApple' }
        And param BottlerSpecificId = '5000'
        And param client_id = '62902dba0c504eeb81d4a237cdcc5105'
        And param client_secret = 'F689deb575a54074Ab0C64aA7837702f'
        And request {}
        When method POST
        Then status 401
        And match response contains 'Authentication failed'

    # Standard when no body provided
    Scenario Outline: '<Test Description>'
      Given url <url>
      And path <path>
      And header Content-Type = 'application/json'
      And header Authorization = call read('../basic-auth.js') { username: 'CloudhubUser4ConaAPI', password: 'GreenApple8964' }
      And param BottlerSpecificId = <BottlerSpecificId>
      And param client_id = <client_id>
      And param client_secret = <client_secret>
      And request {}
      When method POST
      Then status 200
      * match response contains 'Error while transforming Request Data'

      Examples:
      | Test Description | url | path |  BottlerSpecificId | client_id | client_secret |
      | 'TC_Order Create_when no body provided' | 'https://order-mycoke-ccna-api-uat.cloudhub.io/api/v1' | 'create' | '4500' | '945e344711d647feac70f56865a6431b' | 'Ad0CDD05e9b64ea29636727BC9F3157E' |
      | 'TC_Order Simulate_when no body provided' | 'https://order-mycoke-ccna-api-uat.cloudhub.io/api/v1' | 'simulate' | '4500' | '945e344711d647feac70f56865a6431b' | 'Ad0CDD05e9b64ea29636727BC9F3157E' |
