# loginr
Tool for evading account inactivity checks on websites

**Are you a member of a website that purges your account if you don't log in every so often?**

**Is this a pain in the ass?**

**Loginr is for you!**

Loginr can log into any site that doesn't have a captcha on its login page.

# Installation/usage

1. Clone this repo
2. `bundle install` (I use Mechanize, make sure you have development libraries for zlib installed)
3. Edit login.yml to add whatever websites you want to log in to
4. Add this script to a cron job, ideally not more than once a day or every few days.
