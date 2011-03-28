# Pacruft

Print packages whose files have not been accessed in a while.

This list is meant to be a best-guess indication of packages which you 
seldom use and could probably do without.

### Usage

    usage: pacruft [ -q ] [ -3 | -6 | -12 ]
        -3                               set threshold as 3 months
        -6                               set threshold as 6 months
        -12                              set threshold as 1 year
        -q, --quiet                      output only package names
        -h, --help                       display this

### Example output

    --------------------------------------------------------------------------------
    Packages not accessed in the past 6 months:
    --------------------------------------------------------------------------------
    Package                        Last access
    ================================================================================
    bar                            9 months, 24 days ago
    bmpanel                        9 months, 28 days ago
    chkrootkit                     1 year, 4 months, 15 days ago
    gmrun                          1 year, 1 month, 23 days ago
    gtk1-engines                   1 year, 10 months, 16 days ago
    gtk-rezlooks-engine            1 year, 1 month, 23 days ago
    gtk-smooth-engine              9 months, 28 days ago
    libvisual-plugins              7 months, 10 days ago
    qingy-theme-arch               9 months, 28 days ago
    rpmextract                     6 months, 3 days ago
    uudeview                       1 year, 1 month, 23 days ago

### Notes

A 6 month threshold is the default.

Some packages own files that can't be read by an unprivileged user. 
Those packages will be evaluated as if the unreadable file didn't exist.

A package with no readable files will never appear as old.

This script only performs reads, so it's *probably* safe to run as root.

### Why ruby?

It's a language I hadn't used yet.
