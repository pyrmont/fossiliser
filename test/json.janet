(use testament)


(import ../fossiliser/json)


(deftest values
  (def expect 1)
  (def actual (json/decode "1"))
  (is (== expect actual))

  (def expect 100)
  (def actual (json/decode "100"))
  (is (== expect actual))

  (def expect true)
  (def actual (json/decode "true"))
  (is (== expect actual))

  (def expect false)
  (def actual (json/decode "false"))
  (is (== expect actual))

  (def expect :null)
  (def actual (json/decode "null"))
  (is (== expect actual))

  (def expect (range 1000))
  (def actual (json/decode (string/format "[%s]" (-> (map string (range 1000)) (string/join ", ")))))
  (is (== expect actual))

  (def expect "👎")
  (def actual (json/decode `"👎"`))
  (is (== expect actual)))


(run-tests!)
