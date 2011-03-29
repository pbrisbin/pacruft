# Pacruft

Print packages whose files have not been accessed in over 6 months.

This list is meant to be a best-guess indication of packages which you 
seldom use and could probably do without.

### Usage

    Usage: pacruft [options]
        -3                               set threshold as 3 months
        -6                               set threshold as 6 months
        -12                              set threshold as 1 year
        -h, --help                       display this

### Example output

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

A 6 month threshold is the default.

Some packages own files that can't be read by an unprivileged user. 
Those packages will be evaluated as if the unreadable file didn't exist.

A package with no readable files will never appear as old.

This script only performs reads, so it's *probably* safe to run as root.
