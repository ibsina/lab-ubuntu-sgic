import click
import time
import random
from selenium import webdriver

# 2024062601 - Ferry Kemps : Initial script to simulate human login on DVWA with Selenium

#  from selenium.webdriver import ActionChains
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys

#
@click.command()
@click.option("--url_login", "urllogin", type=str, required=True)
@click.option("--username_id", "username_id", type=str, required=True)
@click.option("--error_class", "errorfield", type=str, required=True)
def automate(urllogin, username_id, errorfield):
    options = webdriver.ChromeOptions()
    options.add_argument("--start-maximized")
    options.add_argument('--password-store=basic')
    options.add_experimental_option("prefs",
                                    {
                                        "credentials_enable_service": False,
                                        "profile.password.manager_enabled": False
                                    })
    driver = webdriver.Chrome(options=options)
    #  action = ActionChains(driver)
    driver.get(urllogin)
    username = "admin"
    password = "password"
    driver.implicitly_wait(0.3)
    time.sleep(1)
    driver.find_element(By.NAME, username_id).click()
    active_element = driver.switch_to.active_element
    for letter in username:
        active_element.send_keys(letter)
        time.sleep(random.uniform(0, 0.1))

    time.sleep(1)
    active_element.send_keys(Keys.TAB)
    active_element = driver.switch_to.active_element
    for letter in password:
        active_element.send_keys(letter)
        time.sleep(random.uniform(0, 0.1))

    active_element.send_keys(Keys.ENTER)
    #  Check content after send credentials
    time.sleep(1)
    if driver.find_elements(By.CLASS_NAME, errorfield):
        print("Login Successfull")
    else:
        print("Login Failed")

#    time.sleep(1)
    driver.quit()


if __name__ == "__main__":
    automate()
