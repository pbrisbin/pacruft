# Pacruft

Print packages whose files have not been accessed in a while.

### Todo

* $threshold is a hard-coded 6 months. Allow this to be set as a flag
* Allow a `-q` flag to print only packages (for feeding scripts)
* PKGBUILD?

### Example output

    --------------------------------------------------------------------------------
     Files not accessed in the past 6 months:
    --------------------------------------------------------------------------------
    Package                        Most recent access
    ================================================================================
    bar                            9 months, 24 days, 39 minutes, 3 seconds ago
    bmpanel                        9 months, 28 days, 57 minutes, 16 seconds ago
    chkrootkit                     1 year, 4 months, 15 days, 9 minutes, 42 seconds ago
    gmrun                          1 year, 1 month, 23 days, 38 minutes, 23 seconds ago
    gtk1-engines                   1 year, 10 months, 16 days, 59 minutes, 47 seconds ago
    gtk-rezlooks-engine            1 year, 1 month, 23 days, 39 minutes, 45 seconds ago
    gtk-smooth-engine              9 months, 28 days, 56 minutes, 21 seconds ago
    libvisual-plugins              7 months, 10 days, 45 minutes, 11 seconds ago
    qingy-theme-arch               9 months, 28 days, 56 minutes, 31 seconds ago
    rpmextract                     6 months, 2 days, 6 minutes, 46 seconds ago
    uudeview                       1 year, 1 month, 23 days, 38 minutes, 54 seconds ago
