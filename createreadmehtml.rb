require 'rdoc'

data = File.read("README.rdoc")
formatter = RDoc::Markup::ToHtml.new(RDoc::Options.new,nil)
html = RDoc::Markdown.parse(data).accept(formatter)
open('readme.html','w'){ |f|
	f.puts html
}
