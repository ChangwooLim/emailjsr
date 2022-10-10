#' @export
#'
#' @import glue
#' @import htmltools
#'
#' @param serviceId emailjs.com Service Id
#' @param userID emailjs.com User Id
#' @param templateId emailjs.com Template Id
#' @param success Message when sending mail succeed
#' @param fail Message when sending mail failed
#' @param templateParams A list

use_feedback <- function(serviceId = NULL, userId = NULL, templateId = NULL,
                         success = "E-mail Sent.", fail = "Failed",
                         templateParams = NULL) {
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
