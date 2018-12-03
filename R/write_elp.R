write_elp <- function(..., append, warn, soft) {
  assert_that(is.logical(warn))
  assert_that(is.logical(soft))
  assert_that(is.null(append) || is.list(append))

  elp <- list(...)
  if (!is.null(append))
    elp <- c(append, elp)
  elp.names <- names(elp)
  unique.names <- unique(elp.names)

  # flags of conflicting with the given argments
  conflict.flags <- logical(length(unique.names))
  # index of ellipsis that is used for the returned
  elp.use.index <- numeric(length(unique.names))

  for (i in 1:length(unique.names)) {

    hit.index <- which(elp.names == unique.names[i])

    if (length(hit.index) > 1)
      conflict.flags[i] <- TRUE

    if (soft)
      elp.use.index[i] <- min(hit.index)
    else
      elp.use.index[i] <- max(hit.index)

  }

  if (warn && TRUE %in% conflict.flags){
    if (soft)
      warning("arguments ",
              paste(unique.names[conflict.flags], "", collapse = "and "),
              "conflicted with default values")
    else
      warning("arguments ",
              paste(unique.names[conflict.flags], "", collapse = "and "),
              "is rejected")
  }

  return(elp[elp.use.index])
}

#' Over/soft write some default values to the ellipsis `...`.
#'
#' Set default value to the ellipsis `...`.
#' When conflicts user's specific and the default value,
#' `overwrite_elp()` prioritize default value
#' and `softwrite_elp()` user's specific.
#' Note that when chain over/soft write_elp,
#' use `overwrite_elp()` firstly or set `warn = FALSE` like example code..
#'
#' The ellipsis `...` is used in for example the `plot` function frequently
#' to provide flexible visualization.
#' When we implement the `plot` function as the S3 generic method or others,
#' we want to set the default graphics parameters such as `xlab` or `title`
#' to `...` in some cases.
#' `overwrite_elp()` and `softwrite_elp()` can set defaults to `...` easily,
#' and control rejecting or accepting user's specific parameters.
#' @param ... the ellipsis `...` and default values to be setted.
#' @param append a list of arguments.
#' Mostly the return of `overwrite_elp` or `softwrite_elp`.
#' @param warn if `TRUE`, warn when conflicts user's specific and default value.
#' @return overwrited ellipsis.
#' @export
#' @rdname write_elp
#' @examples
#' # plot function with xlim = c(0, 2 * pi) and col = 'red'
#' # but col is arbitrary changeable
#' plot2pi <- function(x, ...){
#'   elp <- overwrite_elp(..., x = x, xlim = c(0, 2 * pi), ylab = "amplitude")
#'   elp <- softwrite_elp(..., append = elp, col = "red")
#'   do.call(plot, elp)
#' }
#'
#' plot2pi(sin)
#'
#' # col and title is accepted
#' plot2pi(cos, col = "blue", main = "cosine curve")
#'
#' # xlim and ylab is rejected and warned
#' plot2pi(tan, xlim = c(-pi, pi), xlab = "phase", ylab = "tangent")
overwrite_elp <- function(..., append = NULL, warn = TRUE) {
  write_elp(..., warn = warn, soft = FALSE, append = append)
}

#' @export
#' @rdname write_elp
softwrite_elp <- function(..., append = NULL, warn = FALSE) {
  write_elp(..., warn = warn, soft = TRUE, append = append)
}
