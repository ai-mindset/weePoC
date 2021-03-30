using Genie, Genie.Router, Genie.Renderer.Html, Genie.Requests
using Images
using ImageMagick
using SQLite
using DataFrames
using Metalhead
using Metalhead: classify

form = """
<form action="/" method="POST" enctype="multipart/form-data">
<input type="file" name="yourfile" /><br/>
<input type="submit" value="Submit" />
</form>
"""

"""
    savetoDB(dbname, imagename, result, request)
Save to database
Inputs: 
dbname = database name e.g. db.sqlite
imagename = name of selected image
result = classification label of selected image
postpld = postpayload() 
"""
function savetoDB(dbname::String,  imagename::String, result::String, req::String)
    db = SQLite.DB(dbname)
    SQLite.execute(db, "CREATE TABLE IF NOT EXISTS results(Request_time TEXT, Request TEXT, Image_Name TEXT, Image_Label TEXT)")
    query = "INSERT INTO results VALUES(date('now'),'" * req * "','" * imagename * "','" * result * "')"
    SQLite.execute(db, query)
    @show DBInterface.execute(db, "SELECT * FROM results") |> DataFrame
end


"""
    classification(file)
Classifying imagenames using VGG19
Inputs:
file = imagename filename
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
imagename = filename of submited file
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
            imagename = filename(filespayload(:yourfile)) # Extract file name string 
            result = classification(imagename)
            savetoDB(dbname, imagename, result, String(request()))
        else
            "No file uploaded"
        end
    end
    
    # Launch server, keep connection alive with async = false
    up(port, async = false)  
end


port = parse(Int, ARGS[1]) # Port as input arg
fileupload(form, port, "db.sqlite")
