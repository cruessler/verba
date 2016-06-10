# This is a simple solution for compiling Elm into Javascript ready to be
# processed by the asset pipeline.
#
# It’s obviously not going to scale and should be replaced by a proper
# integration into the Rails toolchain if the amount of Elm code grows
# significantly.

puts "Compiling Elm code"

puts `elm make app/assets/elm/Question.elm --output app/assets/javascripts/elm.js`
