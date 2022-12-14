#'
#' @title use_emailjsr_ui
#' @description emailjs.com R support
#' @import shiny
#' @importFrom shinybrowser detect
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

use_emailjsr_ui2 <- function(id, message = "Show feedback modal") {
  ns <- NS(id)
  actionButton(ns("showmodal"), message)
}

#'
#' @title use_emailjsr_server
#' @description emailjs.com R support
#' @import httr
#' @import shiny
#' @import shiny.i18n
#' @importFrom shinybrowser get_width get_height get_user_agent detect
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
#' @param template_params Params passed to emailjs.com
#' @export
#'

use_emailjsr_server2 <- function(id, service_id, user_id, template_id, access_token, language = "en", modal = NULL) {
  url <- "https://api.emailjs.com/api/v1.0/email/send"

  i18n <- Translator$new(translation_json_path = "https://raw.githubusercontent.com/ChangwooLim/emailjsr/main/inst/i18n/translation.json")
  i18n$set_translation_language(language)

  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    text <- function(name, description, placeholder = "", required = FALSE) {
      textInput(ns(name), i18n$t(description), placeholder = i18n$t(placeholder))
    }

    textArea <- function(name, description, placeholder = "", required = FALSE) {
      textAreaInput(ns(name), i18n$t(description), placeholder = i18n$t(placeholder))
    }

    dataModal <- function(failed = FALSE, sent = FALSE) {
      if (is.null(modal)) {
        modal <- list(
          c("text", "name", "Your Name", "John Doe", required = FALSE),
          c("text", "email", "Your E-mail", "Jemail@example.come", required = FALSE),
          c("textArea", "feedback", "Feedback *", "i.e: Crash when click 'generate' button. (Required)", required = TRUE)
        )
        modalDialog(
          if (failed == TRUE) {
            span(i18n$t("Feedback is essential."), style = "color: red;")
          },
          if (sent == TRUE) {
            span(i18n$t("Sent Succesfully."), style = "color: red;")
          },
          textOutput(ns("sending")),
          footer = tagList(
            modalButton(i18n$t("Close")),
            actionButton(ns("submit"), i18n$t("Submit"), style = "border-color: #0C1E20;")
          )
        )
      }
      # c(Type, id, Desc, Placeholder)
      modalDialog(
        for (component in modal) {
          switch(component[1],
            "text" = {
              text(component[2], component[3], component[4])
            },
            "textArea" = {
              textArea(component[2], component[3], component[4])
            }
          )
        }
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
          userAgent = tryCatch(shinybrowser::get_user_agent(), error = function(e) ("UserAgent Not Available")),
          browserWidth = tryCatch(shinybrowser::get_width(), error = function(e) ("Width Not Available")),
          browserHeight = tryCatch(shinybrowser::get_height(), error = function(e) ("Height Not Available"))
        )
        withProgress(
          message = i18n$t("Subitting in progress"),
          detail = i18n$t("This may take a while"),
          value = 0,
          {
            for (i in 1:2) {
              incProgress(1 / 2)
              Sys.sleep(0.25)
              if (i == 1) {
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
              }
            }
          }
        )
        showModal(dataModal(sent = TRUE))
      } else {
        showModal(dataModal(failed = TRUE))
      }
    })
  })
}
