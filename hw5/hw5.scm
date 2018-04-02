#lang racket

; Return #t if obj is an empty listdiff, #f otherwise.
(define (null-ld? obj) 
  (if (or (null? obj) (not (pair? obj))) #f 
      (eq? (car obj) (cdr obj))
  )
)

; Return #t if obj is a listdiff, #f otherwise.
(define (ld? obj)
  (cond ((not (pair? obj)) #f)
	((eq? (car obj) (cdr obj)) #t)
	((not (pair? (car obj))) #f)
	(else (ld? (cons (cdr (car obj)) (cdr obj))))
  )
)

; Return a listdiff whose first element is obj and whose remaining elements are
; listdiff. (Unlike cons, the last argument cannot be an arbitrary object; it 
; must be a listdiff.)
(define (cons-ld obj listdiff)
  (cons (cons obj (car listdiff)) (cdr listdiff))
)

; Return the first element of listdiff. Error if listdiff has no elements.
(define (car-ld listdiff)
  (cond ((null-ld? listdiff) (display "error\n"))
        ((ld? listdiff) (car (car listdiff)))
        (else display "error\n")
  )
)

; Return a listdiff containing all but the first element of listdiff. It is an
; error if listdiff has no elements.
(define (cdr-ld listdiff) 
  (cond ((not (ld? listdiff)) (display "error\n"))
        ((null-ld? listdiff) (display "error\n"))
        (else (cons (cdr(car listdiff)) (cdr listdiff)))
  )
)

; Return a newly allocated listdiff of its arguments.
(define (ld obj . a)
  (cons (cons obj a) '())
)

; Return the length of listdiff.
(define (length-ld listdiff) 
  (cond ((not(ld? listdiff)) (display "error\n"))
        ((null-ld? listdiff) 0)
        (else (+ 1 (length-ld (cdr-ld listdiff))))
  )
)

; Return a listdiff consisting of the elements of the first listdiff followed
; by the elements of the other listdiffs. The resulting listdiff is always 
; newly allocated, except that it shares structure with the last argument. 
; (Unlike append, the last argument cannot be an arbitrary object; it must be
; a listdiff.)
(define (append-ld listdiff . a)
  (if (null? a) listdiff (apply append-ld (cons (append (take (car listdiff)
                         (length-ld listdiff)) (car (car a))) (cdr (car a))) 
                         (cdr a))
  )
)

; Return listdiff, except with the first k elements omitted. If k is zero, 
; return listdiff. It is an error if k exceeds the length of listdiff.
(define (ld-tail listdiff k) 
  (cond ((= k 0) listdiff)
        ((< k 0) (display "error\n"))
        ((> k (length-ld listdiff)) (display "error\n"))
        (else (ld-tail (cdr-ld listdiff) (- k 1)))
  )
)

; Return a listdiff that represents the same elements as list.
(define (list->ld list)
  (if (list? list) (apply ld (car list) (cdr list)) (display "error"))
)

; Return a list that represents the same elements as listdiff.
(define (ld->list listdiff) 
  (cond ((not(ld? listdiff)) (display "error\n"))
        ((null-ld? listdiff) '())
	(else (cons (car-ld listdiff) (ld->list (cdr-ld listdiff))))
  ) 
)

; Helper function for map-ld that generates the list
(define (generate ld n)
  (if (or (null-ld? ld ) (not(pair? ld))) '() 
  (cons (list-ref (car (car ld)) n) (generate (cdr ld) n)))
)

; Helper function for map-ld that assists with mapping
(define (map-ld-helper proc m n ld)
  (if (equal? n m) '() (cons (apply proc (generate ld n)) 
      (map-ld-helper proc m (+ 1 n) ld)))
)

; This acts like the standard map function, except that it uses listdiffs
; instead of lists, and it avoids the overhead of converting its listdiff
; arguments to lists.
(define (map-ld proc . listdiffn)
  (let ((n (length-ld (car listdiffn))))
  (map-ld-helper proc n 0 listdiffn))
)

; Return a Scheme expression that is like expr except that it uses listdiff
; procedures instead of the corresponding list procedures.
(define (expr2ld expr)
  (cond ((null? expr) expr)
        ((list? expr) (cons (expr2ld (car expr)) (expr2ld (cdr expr))))
        ((switch expr))
  )
)

; Helper for expr2ld that detects list procedures and converts them to the
; corresponding listdiff procedures.
(define (switch expr) 
  (cond
    [ (equal? expr 'null) 'null-ld]
    [ (equal? expr 'list?) 'ld? ]
    [ (equal? expr 'cons) 'cons-ld ]
    [ (equal? expr 'car) 'car-ld ]
    [ (equal? expr 'cdr) 'cdr-ld ]
    [ (equal? expr 'list) 'ld ]
    [ (equal? expr 'length) 'length-ld ]
    [ (equal? expr 'append) 'append-ld ]
    [ (equal? expr 'list-tail) 'ld-tail ]
    [ (equal? expr 'map) 'map-ld ]
    [ else expr ]
  )
)

; Test cases

; (define ils (append '(a e i o u) 'y))
; (define d1 (cons ils (cdr (cdr ils))))
; (define d2 (cons ils ils))
; (define d3 (cons ils (append '(a e i o u) 'y)))
; (define d4 (cons '() ils))
; (define d5 0)
; (define d6 (ld ils d1 37))
; (define d7 (append-ld d1 d2 d6))
; (define e1 (expr2ld '(map (lambda (x) (+ x 1))
;                           (list (length (list d1)) 2 4 8)
;                           (append (list) (list-tail (list 1 16 32) 1)))))

; (ld? d1)
; (ld? d2)
; (ld? d3)
; (ld? d4)
; (ld? d5)
; (ld? d6)
; (ld? d7)

; (null-ld? d1)
; (null-ld? d2)
; (null-ld? d3)
; (null-ld? d6)

; (car-ld d1)
; (car-ld d2)
; (car-ld d3)
; (car-ld d6)

; (length-ld d1)
; (length-ld d2)
; (length-ld d3)
; (length-ld d6)
; (length-ld d7)

; (define kv1 (cons d1 'a))
; (define kv2 (cons d2 'b))
; (define kv3 (cons d3 'c))
; (define kv4 (cons d1 'd))
; (define d8 (ld kv1 kv2 kv3 kv4))
; (define d9 (ld kv3 kv4))

; (eq? d8 (ld-tail d8 0))
; (equal? (ld->list (ld-tail d8 2))
;         (ld->list d9)) 
; (null-ld? (ld-tail d8 4)) 
; (ld-tail d8 -1) 
; (ld-tail d8 5) 

; (eq? (car-ld d6) ils) 
; (eq? (car-ld (cdr-ld d6)) d1) 
; (eqv? (car-ld (cdr-ld (cdr-ld d6))) 37) 
; (equal? (ld->list d6)
;         (list ils d1 37)) 
; (eq? (list-tail (car d6) 3) (cdr d6))

; (equal? e1 '(map-ld (lambda (x) (+ x 1))
;                     (ld (length-ld (ld d1)) 2 4 8)
;                     (append-ld (ld) (ld-tail (ld 1 16 32) 1))))