(def q1 (apply + (filter #(any-divides? %3 5) (range 1 1000))))

(defn any-divides? [x & divisors]
    (some #(divides? x %) divisors)
)

(defn divides? [x divisor]
    (zero? (rem x divisor))
)


(def q2 (apply + (filter even? (fib 4000000))))

(defn fib [limit]
    (recur-fib limit [0 1])
)

(defn recur-fib [limit x y] (
    let [next-fib (+ x y)]
    (if (> next-fib limit)
        nil
        (cons next-fib (recur-fib limit y next-fib))
    )
))


(def q3 (largest-prime-factor 600851475143))

(defn largest-prime-factor [target] (
    let 
        [
            smallest-factor (first(filter #(divides? target %) (range 2 (inc target))))
        ]
        (if (= smallest-factor target)
            target
            (recur (quot target smallest-factor))
        )
))


(def q4 (last (sort (filter palindrome? 
    (get-combination-products (range 100 1000) (range 100 1000))
))))

(use '[clojure.contrib.combinatorics :only (cartesian-product)])

(defn palindrome? [item] (
    cond
        (nil? item)                         true
        (not (seq? item))                   (palindrome? (seq (str item)))
        (empty? item)                       true
        (= (first item) (last item))        (palindrome? (drop-last (rest item)))
        (not (= (first item) (last item)))  false
))

(defn get-combination-products [a b] (
    distinct
        (map #(* (first %) (last %)) 
            (cartesian-product a b)
        )
))


; combine the prime factors from 1 to 20
(def q5 (* 2 2 2 2 3 3 5 7 11 13 17 19))




; prime number calculation that is not good
(use '[clojure.set :only (difference)])

(defn sieve [candidates current-prime] (
    let [
        sieved (set (map #(* current-prime %) candidates))
    ]
    (remove sieved candidates)
))

(defn find-primes [candidates]
    (if (empty? candidates) 
        nil
        (cons   (first candidates)
                (find-primes (rest 
                    (sieve candidates (first candidates))
                ))
        )
    )
)

(defn get-primes [highest]
    (find-primes (range 2 highest))
)