(import jurl)
(import lemongrass)
(import spork/json)


(defn get-content [node]
  (slice node (if (dictionary? (get node 1)) 2 1)))


(defn- parse-date [datetime]
  (def g ~{:main (* :date :time -1)
           :date '(* (4 :d) "-" (2 :d) "-" (2 :d))
           :time (* "T" '(* (2 :d) ":" (2 :d) ":" (2 :d)) "." :d+ "Z")})
  (def parts (peg/match g datetime))
  (if parts
    parts
    (error "could not parse date")))


(defn ignored-app? [post apps]
  (some (fn [app] (= app (get-in post ["application" "name"])))
        apps))


(defn- mention? [post]
  (not= :null (post "in_reply_to_account_id")))


(defn- no-content? [post]
  (= "" (post "content")))


(defn- slugify [date body]
  (string date
          "-"
          (-> (peg/match ~(between 1 4 (* (any :W) '(some :w))) body)
              (string/join "-")
              (string/ascii-lower))))


(defn- janet->markdown [ds]
  (if (bytes? ds)
    ds
    (do
      (def res @"")
      (def name (first ds))
      (when (= :p name)
        (buffer/push res "\n\n"))
      (each node (get-content ds)
        (buffer/push res (janet->markdown node)))
      res)))


(defn archive
  ```
  Converts a list of statuses to Markdown-formatted strings

  This function reads the JSON file located at `path` (which may be a URL) and
  creates a Markdown-formatted string for each status. The result is returned
  as a table with the keys being the paths to which the strings can be written.

  The following options are available:
  - `:ignored-apps`: ignores statuses created by any of the apps listed in this
    indexed data structure
  - `:mentions?`: includes mentions
  - `:output-dir`: prepends this path to status filenames
  ```
  [path &keys {:ignored-apps ignored-apps
               :mentions? mentions?
               :output-dir output-dir}]
  (default ignored-apps [])
  (def res @{})
  (def sep "/")
  (def output-dir (string output-dir sep))
  (def input (if (os/stat path) (slurp path) (jurl/slurp path)))
  (def posts (json/decode input))
  (each post posts
    (unless (or (and (not mentions?) (mention? post))
                (no-content? post)
                (ignored-app? post ignored-apps))
      (def content @"")
      (def datetime (parse-date (post "created_at")))
      (def body (-> (post "content") (lemongrass/markup->janet) (janet->markdown)))
      (buffer/format content
                     `---
                     date: %s
                     source: %s
                     ---`
                     (string (datetime 0) " " (datetime 1) " +0000")
                     (post "url"))
      (buffer/push content body "\n")
      (put res (string output-dir (slugify (datetime 0) body) ".md") content)))
  res)
