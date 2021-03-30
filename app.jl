using Genie, Genie.Router, Genie.Renderer.Html, Genie.Requests
using Images
using ImageMagick
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
    savetoDB(dbname, chosen, result, postpld)
Save to database
Inputs: 
dbname = database name e.g. db.sqlite
chosen = name of chosen image
result = classification label of chosen image
postpld = postpayload() 
"""
function savetoDB(dbname::String,  chosen::String, result::String, postpld)
    db = SQLite.DB(dbname)
    SQLite.execute(db, "CREATE TABLE IF NOT EXISTS results(Request BLOB, Image_Name TEXT, Image_Label TEXT)")
    query = "INSERT INTO results VALUES(NULL,'" * chosen * "','" * result * "')"
    SQLite.execute(db, query)
    @show SQLite.tables(db)
end


"""
    classification(file)
Classifying images using VGG19
Inputs:
file = image filename
Returns:
classification label string
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
function fileupload(form::String, port::Integer, dbname::String)
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
            savetoDB(dbname, chosen, result, postpayload())
        else
            "No file uploaded"
        end
    end
    
    # Launch server, keep connection alive with async = false
    up(port, async = false)  
end


port = parse(Int, ARGS[1]) # Port as input arg
fileupload(form, port, "db.sqlite")
