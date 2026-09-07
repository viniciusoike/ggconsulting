# Test whether a font family is available

Used to gate font-dependent code paths and tests, and by
[`ct_theme()`](https://viniciusoike.github.io/ggconsulting/reference/ct_theme.md)
to walk its `font_fallback` chain.

## Usage

``` r
has_font(name)
```

## Arguments

- name:

  Font family name, as it appears in the `family` column of
  [`systemfonts::system_fonts()`](https://systemfonts.r-lib.org/reference/system_fonts.html)
  or
  [`systemfonts::registry_fonts()`](https://systemfonts.r-lib.org/reference/register_font.html).

## Value

`TRUE` if `name` matches an available family, `FALSE` otherwise.
Vectorised over `name`.

## Details

Checks both font tables systemfonts maintains: families installed on the
operating system
([`systemfonts::system_fonts()`](https://systemfonts.r-lib.org/reference/system_fonts.html))
*and* families registered for the current session with
[`systemfonts::register_font()`](https://systemfonts.r-lib.org/reference/register_font.html)
([`systemfonts::registry_fonts()`](https://systemfonts.r-lib.org/reference/register_font.html)).
Registered fonts do not appear in the system table, so checking only
that one would silently reject a corporate font a user had registered
from a file rather than installed.

## Examples

``` r
has_font("Arial")
#> [1] FALSE

# Registered fonts count as available, so a client brand font you
# register from a file can be used by name:
if (FALSE) { # \dontrun{
systemfonts::register_font("ClientSans", plain = "~/fonts/ClientSans.ttf")
has_font("ClientSans")
ct_theme(font = "ClientSans")
} # }
```
