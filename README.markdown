# Pretty Formatter for Rails

This is a Rails logger formatter that improves log format, with colors and
additional information.

## Improved log format
It adds severity level (with colour, if colour is enabled), time (in [ISO8601](http://en.wikipedia.org/wiki/ISO_8601)format), hostname, process ID and an optional custom message to each log line. Also it display the stack trace if an exception is logged.

It does also remove log noise like assets get line and blank debug lines.

Here is how a Rails log looks normally:

    Started GET "/backend/sign_in" for 127.0.0.1 at 2013-03-15 12:03:11 -0600
    Processing by Backend::SessionController#new as HTML
    Admin Load (0.4ms)  SELECT "admins".* FROM "admins" WHERE "admins"."id" IS NULL LIMIT 1
    Rendered backend/session/new.html.erb5 12:03:11 -0600


    Started GET "/assets/jquery.inputmask.numeric.extensions.js?body=1" for
    127.0.0.1 at 2013-03-15 12:03:11 -0600


    Started GET "/assets/jquery.inputmask.js?body=1" for 127.0.0.1 at
    2013-03-15 12:03:11 -0600


    Started GET "/assets/turbolinkform.js?body=1" for 127.0.0.1 at 2013-03-15
    12:03:11 -0600


    Started GET "/assets/application.js?body=1" for 127.0.0.1 at 2013-03-15
    12:03:11 -0600

With the no verbose mode - which default in development - here is how the log
looks like:

    INFO Started GET "/backend/sign_in" for 127.0.0.1 at 2013-03-15 12:06:09 -0600
    INFO Processing by Backend::SessionController#new as HTML
    DEBUG   Admin Load (0.5ms)  SELECT "admins".* FROM "admins" WHERE "admins"."id" IS NULL LIMIT 1
    INFO   Rendered backend/session/new.html.erb within layouts/application (61.0ms)
    INFO Completed 200 OK in 133ms (Views: 100.6ms | ActiveRecord: 2.3ms)

With verbose mode - which is enable in production - here is how the log looks
like:

    cbookpro.94429  2013-03-15T12:07:32.84875-06:00 INFO Started GET "/backend/sign_in" for 127.0.0.1 at 2013-03-15 12:07:32 -0600
    cbookpro.94429  2013-03-15T12:07:33.10027-06:00 INFO Processing by Backend::SessionController#new as HTML
    cbookpro.94429  2013-03-15T12:07:33.13193-06:00 DEBUG   Admin Load (0.5ms) SELECT "admins".* FROM "admins" WHERE "admins"."id" IS NULL LIMIT 1
    cbookpro.94429  2013-03-15T12:07:33.19663-06:00 INFO   Rendered backend/session/new.html.erb within layouts/application (57.9ms)
    cbookpro.94429  2013-03-15T12:07:33.26613-06:00 INFO Completed 200 OK in 166ms (Views: 133.1ms | ActiveRecord: 2.3ms)

The host name is truncated to 8 chars - this is by default but configurable
- starting from right to left and the PID number is appended to it.

## Why?
Why creating another Rails logger gem? I have used better_logging gem in the
past, and it just worked fine. But it's not working any more with Rails 4 beta1,
due to a class that better_logging **monkey patch** to add the formatting
capabilities, I did try ay first to fix better_logging to work doing the same
monkey patching on Rails 4, but at some point it didn't feel right.

The better way is to just create a new **Formatter** and tell Rails to use that
formatter instead the **SimpleFormatter** which comes by default, so no more
monkey patching.

## Install
Is quite simple just add this gem to your Gemfile:

    gem 'pretty_formatter'

Open your **application.rb** file and add the following line:

    config.log_formatter = PrettyFormatter.formatter

And you are all set.

## Configuration
If you want to change **PrettyFormatter** configuration, open your
**application.rb** file and just before the line that set our formatter add the
following options:

    PrettyFormatter.suppress_noise = true #|false

This options will remove log lines for asset pipeline and also will remove
empty log lines by default in development mode.

    PrettyFormatter.verbose = true #|false

When this option is set to true, it add to each log line the hostname, pid and
timestamp.

    PrettyFormatter.hostname_maxlen = 8

When verbose mode is enable this setting will control the maximum number of
charcaters to be displayed from the host name, if hostname is longer than this
number, the hostname wil be cut off, starting from right to left.

    PrettyFormatter.custom = 'custom-string'

If verbose mode is enable this custom string will appear at the begining of
each log line.

## Requirements
Rails 3.2+, this means that also works with Rails 4 beta1.

##License
This is distributed under a Creative Commons “Attribution-Share Alike” license.
For details see:
[http://creativecommons.org/licenses/by-sa/3.0/](http://creativecommons.org/licenses/by-sa/3.0/)
