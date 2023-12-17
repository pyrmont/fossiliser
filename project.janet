(declare-project
  :name "Fossil"
  :description "A tool to archive statuses from a user on Mastodon"
  :author "Michael Camilleri"
  :license "MIT"
  :url "https://github.com/pyrmont/fossiliser"
  :repo "git+https://github.com/pyrmont/fossiliser"
  :dependencies ["https://github.com/cosmictoast/jurl"
                 "https://github.com/janet-lang/spork"
                 "https://github.com/pyrmont/argy-bargy"
                 "https://github.com/pyrmont/lemongrass"]
  :dev-dependencies ["https://github.com/pyrmont/testament"])

# Library

(declare-source
  :source ["fossiliser"])

# Executable

(post-deps
  (declare-executable
    :name "fossil"
    :entry "fossiliser/cli.janet"
    :install false))

# Development

(task "dev-deps" []
  (if-let [deps ((dyn :project) :dependencies)]
    (each dep deps
      (bundle-install dep))
    (do
      (print "no dependencies found")
      (flush)))
  (if-let [deps ((dyn :project) :dev-dependencies)]
    (each dep deps
      (bundle-install dep))
    (do
      (print "no dev-dependencies found")
      (flush))))
