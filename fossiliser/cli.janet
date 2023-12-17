(import argy-bargy :as argy)
(import ./init :as fossil)


(def config
  ```
  The configuration for Argy-Bargy
  ```
  {:rules [:path {:default :stdin
                  :help    "The path for the input file."}
           "--ignored-app"  {:help    `Statuses created by an application with
                                      this <name> will be ignored. This option
                                      can be used multiple times.`
                             :kind    :multi
                             :proxy   "name"
                             :short   "i"}
           "--mentions"     {:default false
                             :help    "Include mentions in archive."
                             :kind    :flag
                             :short   "m"}
           "--output-dir"   {:default "."
                             :help    "The directory in which to archive files."
                             :kind    :single
                             :short   "o"}
           "-------------------------------------------"]
   :info {:about "Archive statuses from a user on Mastodon."}})


(defn- main [& args]
  (def parsed (argy/parse-args "fossil" config))
  (def err (parsed :err))
  (def help (parsed :help))

  (cond
    (not (empty? help))
    (do
      (prin help)
      (os/exit (if (get-in parsed [:opts "help"]) 0 1)))

    (not (empty? err))
    (do
      (eprin err)
      (os/exit 1))

    (do
      (def params (parsed :params))
      (def opts (parsed :opts))
      (def input-path (params :path))
      (def input (if (= :stdin input-path)
                   (getline)
                   (slurp input-path)))
      (def posts (fossil/archive input :ignored-apps (opts "ignored-apps")
                                       :mentions? (opts "mentions")
                                       :output-dir (opts "output-dir")))
      (each [path content] (pairs posts)
        (spit path content)))))
