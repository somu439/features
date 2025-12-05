 Scenario Outline: Login with various credentials
    When I enter username "<username>"
    And I enter password "<password>"
    And I click the login button
    Then I should see "<result>"

    Examples:
      | username      | Charlie      | 
      | password      | qwerty789 | 
      | id            | 3     | 
