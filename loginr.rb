#!/usr/bin/env ruby
require 'mechanize'
require 'yaml'
require 'logger'

conffile = YAML.safe_load(File.read('loginr.yml'))
sites = conffile['sites']
die_on_error = conffile['options']['die_on_error']

unless conffile['options']['user_agent']
  puts 'WARNING: No user agent specified. Check your config file.'
  exit 128
end

logger = Logger.new(STDOUT)
logger.info('Starting up')
failures = 0

sites.each do |s|
  site = s[s.keys.first]
  userfield = site['username_field'] || 'username'
  passwordfield = site['password_field'] || 'password'
  formid = site['form'] || 0
  credentials = site['credentials']
  check = site['check']

  failed = false

  # Create a new agent each time to avoid any pollution or tracking
  a = Mechanize.new
  a.user_agent = conffile['options']['user_agent']

  logger.info('Attepting login on ' + s.keys.first)

  begin
    a.get(site['login_url'])
  rescue StandardError => e
    logger.error('Unable to hit the login url')
    logger.error(e.to_s)
    failed = true
    raise e if die_on_error
  end

  loginform = a.page.forms[formid]
  loginform[userfield] = credentials[0]
  loginform[passwordfield] = credentials[1]

  begin
    loginform.submit
    # Mechanize will helpfully give us a ReturnCodeError
    # if we get anything other than 200 or a redirect.
  rescue StandardError => e
    logger.error('Unable to submit the login form')
    logger.error(e.to_s)
    failed = true
  rescue ReturnCodeError => e
    logger.error("Bad return from submitting the form: #{a.returncode}")
    logger.error(e.to_s)
    failed = true
  end

  if check
    unless a.page.content.include? check
      logger.error("Couldn't locate '#{check}' on post-login page")
      failed = true
    end
  end

  if failed
    logger.error("FAILED logging in to #{site}")
    failures += 1
  else
    logger.info("SUCCESSFULLY logged in to #{site}")
  end
end

logger.info("Run complete. #{failures} errors.")
if failures > 0
  exit 1
else
  exit 0
end
