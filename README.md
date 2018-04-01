# loginr
Tool for evading account inactivity checks on websites

**Are you a member of a website that purges your account if you don't log in every so often?**

**Is this a pain in the ass?**

**Loginr is for you!**

# Requirements

* Ruby 2.3
* zlib dev libraries installed (zlib1g-dev on Ubuntu is the necessary package)
* A website without a captcha on its login page

# Installation/usage

1. Clone this repo
2. Run `bundle install`
3. Edit login.yml to add whatever websites you want to log in to
4. Add this script to a cron job, ideally not more than once a day or every few days.

# Tips
## Random execution time
If you want the script to fire off at a random time, you can abuse `perl` which is installed on basically every Linux/BSD distro ever made. Say you want it kicked off every day sometime between 9 and noon? Set the cron to begin at the start of your window, and do `perl -le 'sleep rand 10800' && /path/to/loginr.rb`

`0 9 * * * perl -le 'sleep rand 10800' && /root/loginr.rb`

The number after the 'rand' is the upper limit on the random number selected, which in this case is a number of seconds.

As a bonus, Cron is generally configured to capture output, so you'll get logs of the activity.
