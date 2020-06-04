
PollHandler <- function(callback,
                           filters = NULL) {
  PollHandlerClass$new(callback, filters)
}


PollHandlerClass <- R6::R6Class("PollHandler",
                                   inherit = telegram.bot:::HandlerClass,
                                   public = list(
                                     initialize = function(callback, filters) {
                                       self$callback <- callback
                                       self$filters <- filters
                                     },
                                     
                                     # Methods
                                     is_allowed_update = function(update) {
                                       !is.null(update$poll_result)
                                     },
                                     
                                     # This method is called to determine if an update should be handled by
                                     # this handler instance.
                                     check_update = function(update) {
                                       if (is.Update(update) && self$is_allowed_update(update)) {
                                         if (is.null(self$filters)) {
                                           res <- TRUE
                                         } else {
                                           message <- update$effective_message()
                                           
                                           if (inherits(self$filters, "list")) {
                                             res <- any(unlist(lapply(self$filters, function(func) {
                                               func(message)
                                             })))
                                           } else {
                                             res <- self$filters(message)
                                           }
                                         }
                                       } else {
                                         res <- FALSE
                                       }
                                       
                                       res
                                     },
                                     
                                     # This method is called if it was determined that an update should indeed
                                     # be handled by this instance.
                                     handle_update = function(update, dispatcher) {
                                       self$callback(dispatcher$bot, update)
                                     },
                                     
                                     # Params
                                     callback = NULL,
                                     filters = NULL
                                   )
)
