
# Dev dependencies --------------------------------------------------------

renv::install("devtools")
renv::install("testthat")
renv::install("roxygen2")
renv::install("roxygen2md")
renv::install("rmarkdown")
renv::install("here")

# Dev preps ---------------------------------------------------------------

# Git
usethis::use_git()

# Use {renv}
renv::activate()

# "Add the pipe"
usethis::use_pipe()

# Add package description
usethis::use_package_doc(open = FALSE)

# Use {testthat}
usethis::use_testthat()
usethis::use_package("testthat", type = "Suggests")

# Use markdown in roxygen syntax
usethis::use_roxgen_md()
roxygen2md::roxygen2md()

# Misc
usethis::use_mit_license()
usethis::use_readme_rmd(open = FALSE)
usethis::use_lifecycle()
usethis::use_lifecycle_badge("experimental")
usethis::use_news_md(open = FALSE)

usethis::use_build_ignore(
    c(
        "dev",
        "inst/examples",
        "tests"
    )
)

# Prod dependencies -------------------------------------------------------

# --- Install
renv::install("dplyr")
# renv::install("rappster/confx")

# --- Declare
usethis::use_package("dplyr")
# usethis::use_dev_package("confx", type = "Imports", remote = "rappster/confx")

# Tests -------------------------------------------------------------------

usethis::use_test("wrangling")
usethis::use_test("wr_freq_table")
usethis::use_test("nse")
