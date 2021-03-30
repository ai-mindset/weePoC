using Genie, Genie.Router, Genie.Renderer.Html, Genie.Requests
using SQLite
using Metalhead
using Metalhead: classify

form = """
<form action="/" method="POST" enctype="multipart/form-data">
<input type="file" name="yourfile" /><br/>
<input type="submit" value="Submit" />
</form>
"""

"""
    savetoDB(dbname)
"""
function savetoDB(dbname::String)
    db = SQLite.DB(dbname)
    SQLite.execute(db, "CREATE TABLE IF NOT EXISTS classify_res(ID INTEGER, Request TEXT, 
                                                       Response TEXT, Post BLOB)")
    @show SQLite.tables(db)
end


"""
    classification(file)
Classifying images using VGG19
Inputs:
file = image filename
Returns:
string containing classification label 
"""
function classification(file::String)
    vgg = VGG19()
    img = load(file)
    return classify(vgg, img)
end


"""
    fileupload(form, port)

Handling file uploads
Input: 
form = a form that submits over `POST`
port = port number
Returns:
chosen = filename of submited file
"""
function fileupload(form::String, port::Integer)
    # GET
    route("/") do
        html(form)
    end

    # POST
    route("/", method = POST) do
        if infilespayload(:yourfile)
            write(filespayload(:yourfile)) # Write the canonical binary representation of a value to the given I/O stream or file.
            stat(filename(filespayload(:yourfile))) # Returns a structure whose fields contain information about the file
            chosen = filename(filespayload(:yourfile)) # Extract file name string 
            result = classification(chosen)
            savetoDB("db.sqlite")
        else
            "No file uploaded"
        end
    end

    up(port, async = false) # Launch server. Async keeps connection alive 
end


port = parse(Int, ARGS[1]) # Port as input arg
fileupload(form, port)
