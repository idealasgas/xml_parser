require 'pry'
require_relative 'Parser'

filename = 'xml_example.xml'
file = File.open(filename)

parser = Parser.new(filename)
parser.parse
parser.print_file(file)
parser.print_tree_view
parser.print_tag_counter
parser.print_declaration
parser.print_comments
parser.print_cdata
