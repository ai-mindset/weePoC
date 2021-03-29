using Genie, Genie.Router, Genie.Renderer.Html, Genie.Requests
using Metalhead
using Metalhead: classify

form = """
<form action="/" method="POST" enctype="multipart/form-data">
<input type="file" name="yourfile" /><br/>
<input type="submit" value="Submit" />
</form>
"""




"""
    classification(img)
Classifying images using VGG19
Inputs:
img = RGB array, created by loading an image using ImageMagic's load()
Returns:
string containing classification label 
"""
function classification(img)
    vgg = VGG19()
    return classify(vgg, img)
end


"""
    fileupload(form, ARGS)

Handling file uploads
Input: 
form = a form that submits over `POST`
ARGS = input argument containing port number
Returns:
chosen = filename of submited file
"""
function fileupload(form, ARGS)
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
            classification(chosen)
        else
            "No file uploaded"
        end
    end

    port = parse(Int, ARGS[1]) # Port as input arg
    up(port, async = false) # Launch server. Async keeps connection alive 
end


fileupload(form, ARGS)
