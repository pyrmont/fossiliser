(use testament)


(import ../fossiliser :prefix "")


(deftest basic-test
  (def expect {"/2023-01-01-hello-world.md"
               (string
                 `---
                 date: 2023-01-01 12:00:00 +0000
                 source: https://example.org/@foobar/1
                 ---

                 Hello world.` "\n")})
  (def actual (archive "test/example.json"))
  (is (== expect actual)))


(run-tests!)
