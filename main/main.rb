# frozen_string_literal: true
require 'ruby_grammar_builder'
require 'walk_up'
require_relative walk_up_until("paths.rb")
require_relative './tokens.rb'

# 
# 
# create grammar!
# 
# 
grammar = Grammar.new(
    name: "Prolog",
    scope_name: "source.prolog",
    fileTypes: [
        "prolog",
    ],
    version: "",
)

# 
#
# Setup Grammar
#
# 
    grammar[:$initial_context] = [
        :comments,
        :string,
        :numeric_literal,
        :operators,
        :predicate,
        :variable,
        :symbol,
        :list,
        :paraentheses,
    ]

# 
# Helpers
# 
    part_of_a_variable = /[a-zA-Z_][a-zA-Z_0-9]*/
    # this is really useful for keywords. eg: variableBounds[/new/] wont match "newThing" or "thingnew"
    variableBounds = ->(regex_pattern) do
        lookBehindToAvoid(@standard_character).then(regex_pattern).lookAheadToAvoid(@standard_character)
    end
    variable = variableBounds[part_of_a_variable]
    
# 
# basic patterns
# 
    grammar[:variable] = Pattern.new(
        match: variableBounds[ /[A-Z][a-zA-Z0-9_]*/ ],
        tag_as: "variable.other",
    )
    grammar[:symbol] = Pattern.new(
        match: variableBounds[ /[a-z][a-zA-Z0-9_]*/ ],
        tag_as: "constant.language.symbol punctuation.section.regexp",
    )
    grammar[:paraentheses] = PatternRange.new(
        start_pattern: Pattern.new(
            match: / *+\(/,
            tag_as: "punctuation.parenthesis",
        ),
        end_pattern: Pattern.new(
            match: / *+\)/,
            tag_as: "punctuation.parenthesis",
        ),
        includes: [
            :$initial_context
        ],
    )
    
    # List
    # Function
    # Symbol
    # Assignment
    # underscore
    # is
    # punctuation
        # commas and periods
        # :-
        # !.
    
# 
# imports
# 
    grammar.import(PathFor[:pattern]["comments"])
    grammar.import(PathFor[:pattern]["string"])
    grammar.import(PathFor[:pattern]["numeric_literal"])
    grammar.import(PathFor[:pattern]["predicate"])
    grammar.import(PathFor[:pattern]["list"])
    grammar.import(PathFor[:pattern]["operators"])

#
# Save
#
name = "prolog"
grammar.save_to(
    syntax_name: name,
    syntax_dir: "./autogenerated",
    tag_dir: "./autogenerated",
)