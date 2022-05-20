# wrang 0.0.1.9006 (2022-05-20)

NSE improvements for column names

- Fixed `handle_nse_input()` to allow for column names that are passed as
variables that contain the **actual** value (be it a string or a name/symbol).
These cases have previously been handled as if the variable itself should become
the name. Classical NSE topic. Not solved super nicely yet, but it'll do for the
moment

----------

# wrang 0.0.1.9005 (2022-05-20)

Roll back unnecessary dep_var

- Removed `dev_par` in `wr_freq_table()` as it was unnecessary

----------

# wrang 0.0.1.9004 (2022-05-17)

Added dev_var, .digits_n_rel and .grouping

- Extended `wr_freq_table()`

----------

# wrang 0.0.1.9003 (2022-05-12)

Fixing exports in NAMESPACE

----------

# wrang 0.0.1.9002 (2022-05-09)

- Added `wr_freq_table()`

----------

# wrang 0.0.1.9001 (2022-05-09)

Removed `wr_summarize()`

- Removded `wr_summariz()` as it didn't really provide additional features over `dplyr::summarize()`
- Unit test for `handle_nse_input()`

----------

# wrang 0.0.1.9000 (2022-05-08)

- Added a `NEWS.md` file to track changes to the package.
