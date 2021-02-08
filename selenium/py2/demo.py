import os
from platform import python_version

from selenium import __version__ as selenium_ver
from selenium.webdriver import Chrome, ChromeOptions

print('Docker & Chrome & Selenium Demo...\n')

options = ChromeOptions()
options.add_argument('--no-sandbox')
options.add_argument('--headless')
options.add_argument('--disable-gpu')
options.add_argument('--incognito')

brower = Chrome(options=options)
brower.get('http://icanhazip.com')

print('''VERSION
===
Python: {}
Selenium: {}
Chrome: {}
ChromeDriver: {}
'''.format(python_version(), selenium_ver,
           brower.capabilities['browserVersion'],
           brower.capabilities['chrome']['chromedriverVersion']))

print('''RESULT
===
Current URL:
    {v.current_url}
Page Source:
    {v.page_source}
'''.format(v=brower))

brower.quit()
