(define (filtered-accumulate_r combiner null-value term a next b f)
  (if (> a b)
    null-value
    (if (f a)
      (combiner (term a)
                (accumulate_r combiner null-value term (next a) next b f))
      (accumulate_r combiner null-value term (next a) next b f))))

(define (sum-of-squres-of-prime a b)
  (define (combiner x y)
    (+ x y))
  (define (term x)
    (* x x))
  (define (next x)
    (+ x 1))
  (filtered-accumulate_r combiner 0 term a next b prime?))

(define (product-of-primes-to-n n)
  (define (combiner x y)
    (* x y))
  (define (term x)
    x)
  (define (next x)
    (+ x 1))
  (define (prime-to-n? x)
    (= (gcd x n) 1))
  (filtered-accumulate_r combiner 1 term a next b prime-to-n?))

