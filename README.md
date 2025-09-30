> [!NOTE]
> All of my GitHub repositories have been **archived** and will be migrated to
> Codeberg as I next work on them. This repository either now lives, or will
> live, at:
>
> https://codeberg.org/pbrisbin/pacruft
>
> If you need to report an Issue or raise a PR, and this migration hasn't
> happened yet, send an email to me@pbrisbin.com.

# Pacruft

Print packages whose files have not been accessed in over 6 months (or 
some arbitrary time).

This list is meant to be a best-guess indication of packages which you 
seldom use and could probably do without.

### Usage

    Usage: pacruft [options]
        -y, --years  <years>
        -m, --months <months>
        -d, --days   <days>
        -h, --help

### Example output

    $ pacruft
    bar
    bmpanel
    chkrootkit
    gmrun
    gtk1-engines
    gtk-rezlooks-engine
    gtk-smooth-engine
    libvisual-plugins
    qingy-theme-arch
    rpmextract
    uudeview

### Notes

A 6 month threshold is the default if no options are passed. One month 
is represented simplistically as exactly 30 days.

Multiple options will sum, so `pacruft -m 6 -d 15` would show packages 
not accessed in the past 195 days (`[ 30 * 6 ] + 15`).

If *any* options are passed, the 6 month default is disabled, so 
`pacruft -d 15` would only represent a 15 day threshold.

Some packages own files unreadable by an unprivileged user. These files 
are ignored and the package is evaluated as if the unreadable file(s) 
didn't exist. Additionally, a package with no readable files will never 
appear as old.

This script only performs reads, so it's *probably* safe to run as root 
to get the most accurate listing.

### Installation

    gem install bundler
    git clone http://github.com/pbrisbin/pacruft && cd pacruft
    bundle install
    rake install

