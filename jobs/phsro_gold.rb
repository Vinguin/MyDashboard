require 'selenium-webdriver'


driver = Selenium::WebDriver.for :firefox
driver.manage.timeouts.implicit_wait = 5
driver.manage.window.resize_to(1920, 1080)
driver.navigate.to "https://sro.projecthax.com/"


# Sign in 
driver.find_element(:css, "button.navbar-btn").click
sleep(5)
driver.find_element(:id, "sign-in-username").send_keys "bubchen"
driver.find_element(:id, "sign-in-password").send_keys "vn831993"
driver.find_element(:id, "sign-in").click


sleep(30)
puts driver.page_source


