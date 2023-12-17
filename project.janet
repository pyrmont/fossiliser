(declare-project
  :name "Fossil"
  :description "An archiver of statuses from a Mastodon user"
  :author "Michael Camilleri"
  :license "MIT"
  :url "https://github.com/pyrmont/fossiliser"
  :repo "git+https://github.com/pyrmont/fossiliser"
  :dependencies ["https://github.com/cosmictoast/jurl"
                 "https://github.com/janet-lang/spork"
                 "https://github.com/pyrmont/lemongrass"]
  :exe-dependencies ["https://github.com/pyrmont/argy-bargy"]
  :dev-dependencies ["https://github.com/pyrmont/testament"])

# Library

(declare-source
  :source ["fossiliser"])

(task "deps" []
  (if-let [deps ((dyn :project) :dependencies)]
    (each dep deps
      (bundle-install dep))
    (do
      (print "no dependencies found")
      (flush))))

# Executable

(post-deps
  (declare-executable
    :name "fossil"
    :entry "fossiliser/cli.janet"
    :install false))

(task "exe-deps" ["deps"]
  (if-let [deps ((dyn :project) :exe-dependencies)]
    (each dep deps
      (bundle-install dep))
    (do
      (print "no dev-dependencies found")
      (flush))))

# Development

(task "dev-deps" ["deps"]
  (if-let [deps ((dyn :project) :dev-dependencies)]
    (each dep deps
      (bundle-install dep))
    (do
      (print "no dev-dependencies found")
      (flush))))

# Testing

(task "test-deps" ["dev-deps" "exe-deps"])
