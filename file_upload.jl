using Genie, Genie.Router, Genie.Renderer.Html, Genie.Requests

form = """
<form action="/" method="POST" enctype="multipart/form-data">
  <input type="file" name="yourfile" /><br/>
  <input type="submit" value="Submit" />
</form>
"""

route("/") do
  html(form)
end

route("/", method = POST) do
  if infilespayload(:yourfile)
    write(filespayload(:yourfile))

    stat(filename(filespayload(:yourfile)))
  else
    "No file uploaded"
  end
end

up()
