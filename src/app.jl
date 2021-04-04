using Pkg 
inst = Pkg.installed()
if !haskey(inst, "Genie") || !haskey(inst, "SQLite") || !haskey(inst, "DataFrames") || !haskey(inst, "ImageMagick") || !haskey(inst, "Metalhead")
    print("Downloading and precompiling packages. Please wait... \n")
    Pkg.instantiate() # Install requirements
    print("Required packages installed \n")
end

print("Would you like to update this project's packages? [yes|no] \n")
updtQ = readline()
if updtQ == "yes"
    Pkg.update()
end

Pkg.resolve() # Update the current manifest with eventual changes to the dependency graph from packages that are tracking a path

print("Loading packages... \n")
using Genie.AppServer: up
using Genie.Router: route, POST
using Genie.Renderer.Html: html
using Genie.Requests: request, infilespayload, write, filespayload, filename 
using SQLite: DB, execute, DBInterface
using DataFrames
using ImageMagick
using Metalhead: VGG19, load, classify


"""
    savetoDB(dbname, imagename, result, req)

Save to database
Inputs: 
dbname = database name e.g. db.sqlite
imagename = name of selected image
result = classification label of selected image
postpld = postpayload() 
"""
function savetoDB(dbname::String,  imagename::String, result::String, req::String)
    db = DB(dbname)
    create_table = "CREATE TABLE IF NOT EXISTS results(Request_time TEXT, Request TEXT, Image_Name TEXT, Image_Label TEXT)"
    execute(db, create_table)
    ins = "INSERT INTO results VALUES(date('now'),'" * req * "','" * imagename * "','" * result * "')"
    execute(db, ins)
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


form = """
<form action="/" method="POST" enctype="multipart/form-data">
<input type="file" name="yourfile" /><br/>
<input type="submit" value="Submit" />
</form>
"""

"""
    fileupload(form, port, dbname)

Handling file uploads
Input: 
form = a form that submits over `POST`
port = port number
dbname = database name e.g. db.sqlite
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
print("Please wait, the app is starting... \n")
fileupload(form, port, "db.sqlite")
