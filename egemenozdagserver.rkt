#lang racket

(require web-server/servlet
         web-server/servlet-env
         web-server/http)

;; Function that generates the HTML response
(define (main-page request)
  (define params (request-bindings request)) ; get form data
  (define user-input
    (binding-assq 'message params))          ; extract the "message" field

  ;; Create the HTML response
  (response/xexpr
   `(html
     (head (title "Dynamic Racket Page"))
     (body
      (h1 "Welcome to the Dynamic Racket Web Server!")
      (form ((action "/") (method "post"))
        (label ((for "msg")) "Type a message: ")
        (input ((type "text") (name "message") (id "msg")))
        (input ((type "submit") (value "Send"))))
      ,(if user-input
           `(p "You said: " ,(binding:form-value user-input))
           `(p "Waiting for your message..."))))))

;; Start the server
(define (start-server)
  (serve/servlet
   main-page
   #:launch-browser? #f
   #:servlet-path "/"
   #:port 8000
   #:servlet-regexp #rx""))

(start-server)
