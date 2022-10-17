#'
#' @title use_emailjsr
#' @description emailjs.com R support
#' @import glue
#' @import htmltools
#'
#' @examples
#' library(emailjsr)
#'
#' @rdname use_emailjsr
#'
#' @param serviceId emailjs.com Service Id
#' @param userId emailjs.com User Id
#' @param templateId emailjs.com Template Id
#' @export

use_emailjsr <- function(serviceId = NULL, userId = NULL, templateId = NULL) {
  if (is.null(serviceId) | is.null(userId) | is.null(templateId)) {
    stop("Param serviceId, userId, templateId is Required.")
  }
  return(
    htmltools::tagList(
      tags$script(
        glue::glue(
          .open = "{{{",
          .close = "}}}",
          '
          const serviceId="{{{serviceId}}}";
          const templateId="{{{templateId}}}";
          const userId="{{{userId}}}";
          '
        )
      ),
      includeScript("https://cdn.jsdelivr.net/npm/@emailjs/browser@3/dist/email.min.js"),
      includeCSS("feedback.css"),
      includeHTML("feedback.html"),
      includeScript("www/app.js"),
    )
  )
}
