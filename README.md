# elp

The ellipsis `...` is used in for example the plot function frequently to provide flexible visualization.  

When we implement the plot function as the S3 generic method or others, we want to set the default graphics parameters such as `xlab` and `title` to the ellipsis `...` in some cases.  
Then, to implement proces for setting the default or for rejecting or accepting the user's specific value instead of the default is takes time and effort.  

This package makes the process easily.

## Installation

```r
devtools::install_github("hosscine/elp")
```

## Usage

Now, suppose that we want to customized plot function like below:
- `xlim = c(0, 2 * pi)`
- `xlab = "phase"` (as default)
- `col = "red"` (as default).

### bad example

```r
plot2pi_bad <- function(x, ...) {
  elp <- list(...)
  elp$x <- x
  elp$xlim <- c(0, 2*pi)
  if (is.null(elp$xlab)) elp$phase <- "phase"
  if (is.null(elp$col)) elp$col <- "red"
  do.call(plot, elp)
}
```

In this example, we must write long codes for just setting the default parameters.  
And when user specify `xlim`, this function ignore it without warning.

### good example

```r
plot2pi_good <- function(x, ...){
  elp <- elp::overwrite_elp(..., x = x, xlim = c(0, 2 * pi))
  elp <- elp::softwrite_elp(..., append = elp, xlab = "phase", col = "red")
  do.call(plot, elp)
}
```

This example is more simpler.  
If user specify `xlim`, the function warns that conflict was occured. (controlable by `warn` argument)

### Note
If you chain `elp::overwrite_elp` and `elp::softwrite_elp`, use `overwrite_elp()` firstly like good example code or set `warn = FALSE`.

## Templete

```r
  elp <- elp::overwrite_elp(..., x = x)
  elp <- elp::softwrite_elp(..., append = elp)
  do.call(plot, elp)
```
