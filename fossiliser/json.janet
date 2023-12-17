(def- g
  (peg/compile ~{:main (* :element -1)
                 :element (* :s* :value :s*)
                 :value (+ :object :array :string :number :true :false :null)
                 :object (replace (* "{" (? (* :member (any (* "," :member)))) :s* "}") ,table)
                 :member (* :s* :string :s* ":" :element)
                 :array (replace (* "[" (? (* :element (any (* "," :element)))) :s* "]") ,array)
                 :string (replace '(* `"` :chars `"`) ,parse)
                 :chars (any (+ :escape (if-not `"` 1)))
                 :escape (* `\` (+ (set `"\/bfnrt`) (* "u" (4 :h))))
                 :number (replace '(* :integer (? :fraction) (? :exponent)) ,scan-number)
                 :integer (* (? "-") (+ (* (set "123456789") :d+) :d))
                 :fraction (* "." :d+)
                 :exponent (* (set "Ee") (? (set "+-")) :d+)
                 :true (* "true" (constant true))
                 :false (* "false" (constant false))
                 :null (* "null" (constant :null))}))

(defn decode
  ```
  Decodes JSON into a native Janet data structure
  ```
  [data]
  (first (peg/match g data)))
