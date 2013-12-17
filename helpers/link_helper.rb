def link(path, rel=:self, method=nil)
  a_link = {rel: rel, uri: url(path) }
  a_link[:method] = method if method
  a_link
end