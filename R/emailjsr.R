#'
#' @title send_email
#' @description Send email using emailjs service.
#' @import httr
#' @note You should allow EmailJS API for non-browser applications.
#' @examples
#' library(emailjsr)
#'
#' send_email("service_id", "user_id", "template_id", "access_token", list(name = "John Doe"))
#'
#' @param service_id emailjs.com Service Id
#' @param user_id emailjs.com User Id or Public Key
#' @param template_id emailjs.com Template Id
#' @param template_params Params passed to emailjs.com. You should set template at emailjs.com in prior.
#' @param access_token emailjs.com Access Token or Private Key. Default is NULL in case of you don't use access token.
#' @export
#'

send_email <- function(service_id, user_id, template_id, template_params = list(), access_token = NULL){
  url <- "https://api.emailjs.com/api/v1.0/email/send"

  body = list(
    service_id = service_id,
    user_id = user_id,
    template_id = template_id,
    template_params = template_params
  )

  if(!is.null(access_token)) {
    body <- append(body, list(accessToken = access_token))
  }

  POST(
    url = url,
    body = body,
    encode = "json"
  )
}
