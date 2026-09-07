# Install consulting fonts from Google Fonts

Downloads and installs the font families used by the three archetype
themes
([`theme_strategy()`](https://viniciusoike.github.io/ggconsulting/reference/theme_strategy.md),
[`theme_finance()`](https://viniciusoike.github.io/ggconsulting/reference/theme_finance.md),
[`theme_editorial()`](https://viniciusoike.github.io/ggconsulting/reference/theme_editorial.md)).
All fonts are OFL or Apache-2.0 licensed.

## Usage

``` r
install_consulting_fonts(fonts = NULL, dest = NULL, quiet = FALSE)
```

## Arguments

- fonts:

  Character vector of family names to install, or `NULL` (default) for
  the full set: Inter, Source Sans 3, Lato, Source Serif 4, IBM Plex
  Sans. Validated against the known catalog.

- dest:

  Destination directory. `NULL` (default) uses a platform-appropriate
  user font directory: `~/Library/Fonts` on macOS,
  `~/.local/share/fonts` on Linux, or
  `~/AppData/Local/Microsoft/Windows/Fonts` on Windows. On Windows the
  fonts are also registered for the current R session with
  [`systemfonts::register_font()`](https://systemfonts.r-lib.org/reference/register_font.html),
  because files in the per-user folder are not visible to other
  applications until they are installed (right-click \> Install).

- quiet:

  Suppress informational messages. Errors are always emitted. Defaults
  to `FALSE`.

## Value

Invisibly, a character vector of installed file paths.

## Details

Variable-weight families (Inter, Source Sans 3, Source Serif 4, IBM Plex
Sans) are downloaded as variable `.ttf` files containing all weights
(Light through Bold and beyond). Lato is downloaded as four static
`.ttf` files (Regular, Bold, Italic, Light).

## Consent

Installing to the default destination writes font files into your home
directory and downloads roughly 9 MB from the network. Because that is
outside the R session, this function never does it silently: in an
interactive session it asks for confirmation first, and in a
non-interactive one it aborts. To install unattended, either pass an
explicit `dest` or set `options(ggconsulting.font_consent = TRUE)`. No
confirmation is asked when `dest` is supplied, since the caller has then
named the directory themselves.

## Examples

``` r
if (FALSE) { # \dontrun{
install_consulting_fonts()
install_consulting_fonts("Inter")

# Unattended, into a directory you choose:
install_consulting_fonts("Inter", dest = tempdir())
} # }
```
