#'
#' @title use_emailjsr_ui
#' @description emailjs.com R support
#' @import shiny
#'
#' @examples
#' library(shiny)
#' library(emailjsr)
#' ui <- fluidPage(
#'   use_emailjsr_ui("id")
#' )
#'
#' server <- function(input, output, session) {
#'   emailjsr::use_emailjsr_server("id",
#'     service_id = "Your_service_id",
#'     template_id = "Your_template_id", user_id = "Your_user_id",
#'     access_token = "Your_Access_Token"
#'   )
#' }
#'
#' @rdname use_emailjsr
#'
#' @param id Should be same to id of use_emailjsr_server.
#' @param message Messege on button.
#' @export

use_emailjsr_ui <- function(id, message = "Show feedback modal") {
  ns <- NS(id)
  actionButton(ns("showmodal"), message)
}

#'
#' @title use_emailjsr_server
#' @description emailjs.com R support
#' @import httr
#' @import shiny
#' @importFrom shinybrowser get_width get_height
#' @examples
#' library(shiny)
#' library(emailjsr)
#' ui <- fluidPage(
#'   use_emailjsr_ui("id")
#' )
#'
#' server <- function(input, output, session) {
#'   emailjsr::use_emailjsr_server("id",
#'     service_id = "Your_service_id",
#'     template_id = "Your_template_id", user_id = "Your_user_id",
#'     access_token = "Your_Access_Token"
#'   )
#' }
#' @param id Should be same to id of use_emailjsr_ui
#' @param service_id emailjs.com Service Id
#' @param user_id emailjs.com User Id
#' @param template_id emailjs.com Template Id
#' @param access_token emailjs.com Access Token
#' @export
#'

use_emailjsr_server <- function(id, service_id, user_id, template_id, access_token) {
  url <- "https://api.emailjs.com/api/v1.0/email/send"
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    dataModal <- function(failed = FALSE) {
      modalDialog(
        textInput(ns("name"), "Your Name",
          placeholder = "Your Name"
        ),
        textInput(ns("email"), "Your E-mail",
          placeholder = "Your E-mail"
        ),
        textAreaInput(ns("feedback"), "Feedback *",
          placeholder = "Type down your feedback to developer. (Required)"
        ),
        if (failed == TRUE) {
          span("Feedback is essential.", style = "color: red;")
        },
        footer = tagList(
          modalButton("Cancel"),
          actionButton(ns("submit"), "Submit")
        )
      )
    }

    observeEvent(input$showmodal, {
      showModal(dataModal())
    })

    observeEvent(input$submit, {
      if (!(input$feedback == "")) {
        template_params <- list(
          fromName = input$name,
          message = input$feedback,
          replyTo = input$email,
          userAgent = tryCatch(getOption("HTTPUserAgent"), error = function(e) ("UserAgent Not Available")),
          browserWidth = tryCatch(shinybrowser::get_width(), error = function(e) ("Width Not Available")),
          browserHeight = tryCatch(shinybrowser::get_height(), error = function(e) ("Height Not Available"))
        )
        POST(
          url = url,
          body = list(
            service_id = service_id,
            template_id = template_id,
            user_id = user_id,
            accessToken = access_token,
            template_params = template_params
          ),
          encode = "json"
        )
        removeModal()
      } else {
        showModal(dataModal(failed = TRUE))
      }
    })
  })
}
