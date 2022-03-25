#lang br/quicklang
(require racket/block)
(require racket/string)

(define (newline str) (string-append-immutable str "\n"))

(define (sum-helper op acc stack)
    (if (equal? stack empty)
        acc
        (block
          (define a (first stack))
          (sum-helper op (op a acc) (rest stack)))))

; (define (^ stack) (display (newline (~v (first stack)))))
(define ($ stack) (first stack))
(define (% stack) (cons stack stack))
(define (! stack) (cons stack (length stack)))
(define / empty)
(define λ null)
(define (~ stack) (cons null stack))
(define (& stack) (reverse stack))
(define (: stack) (cons (first stack) stack))
(define (+! stack)
  (cons (sum-helper + 0 stack) stack))
(define (*! stack)
  (cons (sum-helper * 0 stack) stack))

(define (handle-args . args)
  (for/fold ([stack-acc empty])
            ([arg (in-list args)])
    (match arg
      [(? number? arg) (cons arg stack-acc)]
      [(? string? arg) (cons arg stack-acc)]
      [(== /)
       arg]
      [(or (== %) (== !) #| (== ^) |# (== $) (== &) (== :) (== ~) (== *!) (== +!))
       (arg stack-acc)]
      [(or (== +) (== *))
       (define op-result (arg (first stack-acc) (second stack-acc)))
       (cons op-result (drop stack-acc 2))]
      [(== λ)
       (raise "revenge of the lambda" #t)])))
(provide handle-args)

(provide + * #| ^ |# $ % ! +! λ / & : *! ~)