--
-- Notion statusbar module configuration file
-- 


-- Create a statusbar
mod_statusbar.create{
    -- First screen, bottom left corner
    screen=0,
    pos='tl',
    -- Set this to true if you want a full-width statusbar
    fullsize=true,
    -- Swallow systray windows
    systray=true,

    -- Template. Tokens %string are replaced with the value of the 
    -- corresponding meter. Currently supported meters are:
    --   date          date
    --   load          load average (1min, 5min, 15min)
    --   load_Nmin     N minute load average (N=1, 5, 15)
    --   mail_new      mail count (mbox format file $MAIL)
    --   mail_unread   mail count
    --   mail_total    mail count
    --   mail_*_new    mail count (from an alternate mail folder, see below)
    --   mail_*_unread mail count
    --   mail_*_total  mail count
    --
    -- Space preceded by % adds stretchable space for alignment of variable
    -- meter value widths. > before meter name aligns right using this 
    -- stretchable space , < left, and | centers.
    -- Meter values may be zero-padded to a width preceding the meter name.
    -- These alignment and padding specifiers and the meter name may be
    -- enclosed in braces {}.
    --
    -- %filler causes things on the marker's sides to be aligned left and
    -- right, respectively, and %systray is a placeholder for system tray
    -- windows and icons.
    --
    template="[ %exec_finger || %exec_battery || %load || %exec_pom ] %filler%systray",
    -- template="[ %exec_finger || %exec_battery || %exec_undate (%exec_utc) %exec_death || %load || %exec_pom ] %filler%systray",
    --template="[ %date || load:% %>load || mail:% %>mail_new/%>mail_total ] %filler%systray",
    --template="[ %date || load: %05load_1min || mail: %02mail_new/%02mail_total ] %filler%systray",
}


-- Launch ion-statusd. This must be done after creating any statusbars
-- for necessary statusd modules to be parsed from the templates.
mod_statusbar.launch_statusd{
    -- Date meter
    date={
        -- ISO-8601 date format with additional abbreviated day name
        date_format='%a %Y-%m-%d %H:%M',
        -- Finnish etc. date format
        --date_format='%a %d.%m.%Y %H:%M',
        -- Locale date format (usually shows seconds, which would require
        -- updating rather often and can be distracting)
        --date_format='%c',
        
        -- Additional date formats. 
        formats={ 
            time = '%H:%M', -- %date_time
        }
    },      

    -- Load meter
    load={
        --update_interval=10*1000,
        --important_threshold=1.5,
        --critical_threshold=4.0,
    },

    -- Mail meter
    --
    -- To monitor more mbox files, add them to the files table.  For
    -- example, add mail_work_new and mail_junk_new to the template
    -- above, and define them in the files table:
    --
    -- files = { work = "/path/to/work_email", junk = "/path/to/junk" }
    --
    -- Don't use the keyword 'spool' as it's reserved for mbox.
    mail={
        --update_interval=60*1000,
        --mbox=os.getenv("MAIL"),
        --files={},
    },

    exec = {
        finger = {
            program = 'check-mail-new',
            retry_delay = 60 * 1000,
            hint_regexp = {
	critical = '[^0].*/',
	important = '/[^0]'
            },
        },

        backup = {
            program = 'true notify-backup-quality',
            retry_delay = 15 * 60 * 1000,
            hint_regexp = {
	critical = '[^0/]'
            },
        },

        utc = {
            program = "combine-inputs / 'date -u +%HZ' 'TZ=America/Los_Angeles date +%HP'",
            retry_delay = 60 * 1000,
        },

        undate = {
            program = 'currently-unscheduled',
            retry_delay = 60 * 1000,
            hint_regexp = {
	important = ' $',
            },
        },

        goal = {
            -- program = '{ true goal-check; true goal-warn; echo foo} | sponge | head -n1 | grep . || echo ',
            program = 'elapsed',
            retry_delay = 5 * 60 * 1000,
        },

        assets = {
            program = 'true dhlr notion',
            retry_delay = 5 * 60 * 1000,
            hint_regexp = {
	critical = '[0-2][0-9]$',
	important = '[3-8][0-9]$',
            },
        },

        pom = {
            program = 'print-pom-info',
            retry_delay = 15 * 1000,
        },

        battery = {
            program = 'print-battery-status',
            retry_delay = 15 * 1000,
            hint_regexp = {
	important = '^[2-4]',
	critical = '^[01][0-9]$'
            },
        },

        work = {
            program = 'combine-inputs / "print-work-commitment A" "print-work-commitment B"',
            retry_delay = 10 * 60 * 1000,
        },

        play = {
            program = 'combine-inputs / "print-work-commitment P" "cat ~/ref/goal.playpom"',
            retry_delay = 10 * 60 * 1000,
        },

        death = {
            program = 'deathcountdown',
            retry_delay = 10 * 60 * 1000,
        },

        alphaomega = {
            program = 'alpha-omega',
            retry_delay = 10 * 60 * 1000,
        },
    },
                 

}

